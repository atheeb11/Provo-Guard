FROM node:20-alpine

WORKDIR /app

# Copy package files from the backend folder and install dependencies
COPY guardian_ai_backend/package*.json ./
RUN npm install --omit=dev

# Copy the rest of the backend files
COPY guardian_ai_backend/ ./

# Expose port 7860 (Hugging Face Spaces expects port 7860)
EXPOSE 7860
ENV PORT=7860
ENV NODE_ENV=production

# Start application
CMD ["node", "src/server.js"]
