FROM node:18-alpine AS base
ENV NEXT_TELEMETRY_DISABLED=1
WORKDIR /app

# Install dependencies using pnpm (via Corepack)
FROM base AS deps
RUN corepack enable
# Use a more recent pnpm version that supports lockfile v6
RUN corepack prepare pnpm@8.15.0 --activate
COPY package.json pnpm-lock.yaml ./
# If lockfile is incompatible, regenerate it
RUN pnpm install --frozen-lockfile || pnpm install

# Build the Next.js app
FROM base AS builder
RUN corepack enable
RUN corepack prepare pnpm@8.15.0 --activate
COPY package.json pnpm-lock.yaml ./
COPY --from=deps /app/node_modules ./node_modules
COPY pages/ ./pages/
COPY components/ ./components/
COPY theme.config.tsx ./
COPY tsconfig.json ./
COPY next.config.js ./
RUN pnpm build

# Production runtime
FROM base AS runner
ENV NODE_ENV=production
RUN corepack enable
RUN corepack prepare pnpm@8.15.0 --activate
USER node

# Copy only what is needed to run
COPY --chown=node:node --from=builder /app/.next ./.next
COPY --chown=node:node package.json pnpm-lock.yaml ./
COPY --chown=node:node --from=deps /app/node_modules ./node_modules

EXPOSE 3000

# Ensure Next binds to all interfaces in Docker
CMD ["pnpm", "start", "--", "-H", "0.0.0.0", "-p", "3000"]


