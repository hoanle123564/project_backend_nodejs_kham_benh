const FASTAPI_AI_BASE_URL =
  process.env.FASTAPI_AI_BASE_URL || "http://127.0.0.1:8000";

const normalizeArray = (value) => {
  if (!value) return [];
  if (Array.isArray(value)) return value.filter(Boolean);
  return [value].filter(Boolean);
};

const normalizeAiResult = (responseJson) => {
  const normalized = responseJson?.normalized || {};

  return {
    intent: normalized.intent || null,
    intent_score: normalized.intent_score ?? normalized.intentScore ?? null,
    symptoms: normalizeArray(normalized.symptoms),
    duration: normalized.duration || null,
    consultation_type: normalized.consultation_type || null,
    location: normalized.location || null,
    specialties: normalizeArray(normalized.specialties || normalized.specialty),
    preferred_date: normalized.preferred_date || null,
  };
};

const analyzeMessage = async (message) => {
  if (!global.fetch) {
    throw new Error("Native fetch is unavailable. Please run Node.js 18+.");
  }

  const response = await fetch(`${FASTAPI_AI_BASE_URL}/chat/analyze`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ message }),
  });

  let responseJson = null;
  try {
    responseJson = await response.json();
  } catch (error) {
    responseJson = null;
  }

  if (!response.ok || !responseJson?.success) {
    const detail =
      responseJson?.detail ||
      responseJson?.message ||
      `FastAPI AI service returned ${response.status}`;
    throw new Error(detail);
  }

  return {
    success: true,
    normalized: normalizeAiResult(responseJson),
    raw: responseJson,
  };
};

module.exports = {
  analyzeMessage,
};
