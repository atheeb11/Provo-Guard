FROM node:20-alpine

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy source code
COPY . .

# Expose port 7860 (Hugging Face Spaces requires port 7860)
EXPOSE 7860
ENV PORT=7860
ENV NODE_ENV=production

# Start application
CMD ["node", "src/server.js"]
