const {
  approvePayosRefund,
  createPatientRefund,
  listManagementRefunds,
  listPatientRefunds,
  rejectPayosRefund,
  syncPayosRefund,
} = require("../service/refundService");
const {
  CONFLICT_RESPONSE,
  FORBIDDEN_RESPONSE,
  getR4ClinicScope,
} = require("../service/clinicAccessService");

const send = (res, response, fallbackStatus = 200) => {
  const { httpStatus, ...body } = response || {};
  const status = httpStatus || (body.errCode === 403 ? 403 : body.errCode === 404 ? 404 : body.errCode === 409 ? 409 : fallbackStatus);
  return res.status(status).json(body);
};

const postPatientRefund = async (req, res) => send(res, await createPatientRefund({ user: req.user, body: req.body }));
const getPatientRefunds = async (req, res) => {
  if (req.user?.roleId !== "R3") return send(res, { errCode: 403, errMessage: "Permission denied" });
  return send(res, await listPatientRefunds(req.user.id));
};
const getPatientRefund = async (req, res) => {
  if (req.user?.roleId !== "R3") return send(res, { errCode: 403, errMessage: "Permission denied" });
  return send(res, await listPatientRefunds(req.user.id, req.params.refundId));
};

const getAdminRefunds = async (_req, res) => send(res, await listManagementRefunds());
const postAdminApproveRefund = async (req, res) => send(res, await approvePayosRefund({ refundId: req.params.refundId, actor: req.user }));
const postAdminRejectRefund = async (req, res) => send(res, await rejectPayosRefund({ refundId: req.params.refundId, actor: req.user, reason: req.body?.rejectionReason ?? req.body?.reason }));
const postAdminSyncRefund = async (req, res) => send(res, await syncPayosRefund({ refundId: req.params.refundId }));

const getClinicManagerScope = async (req, res) => {
  const scope = await getR4ClinicScope(req.user);
  if (scope.errCode === 0) return scope;
  send(res, scope.errCode === 409 ? CONFLICT_RESPONSE : FORBIDDEN_RESPONSE);
  return null;
};

const getClinicManagerRefunds = async (req, res) => {
  const scope = await getClinicManagerScope(req, res);
  return scope ? send(res, await listManagementRefunds(scope.clinicId)) : undefined;
};
const postClinicManagerApproveRefund = async (req, res) => {
  const scope = await getClinicManagerScope(req, res);
  return scope ? send(res, await approvePayosRefund({ refundId: req.params.refundId, actor: req.user, clinicId: scope.clinicId })) : undefined;
};
const postClinicManagerRejectRefund = async (req, res) => {
  const scope = await getClinicManagerScope(req, res);
  return scope ? send(res, await rejectPayosRefund({ refundId: req.params.refundId, actor: req.user, clinicId: scope.clinicId, reason: req.body?.rejectionReason ?? req.body?.reason })) : undefined;
};
const postClinicManagerSyncRefund = async (req, res) => {
  const scope = await getClinicManagerScope(req, res);
  return scope ? send(res, await syncPayosRefund({ refundId: req.params.refundId, clinicId: scope.clinicId })) : undefined;
};

module.exports = {
  getAdminRefunds,
  getClinicManagerRefunds,
  getPatientRefund,
  getPatientRefunds,
  postAdminApproveRefund,
  postAdminRejectRefund,
  postAdminSyncRefund,
  postClinicManagerApproveRefund,
  postClinicManagerRejectRefund,
  postClinicManagerSyncRefund,
  postPatientRefund,
};
