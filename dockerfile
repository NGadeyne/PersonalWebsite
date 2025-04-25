# Étape 1 : Image de base avec Node et installation des dépendances
FROM node:23-slim AS build

# Crée un répertoire pour l’app
WORKDIR /app

# Copie les fichiers de dépendances
COPY package.json package-lock.json ./

# Installe les dépendances
RUN npm ci

# Installe Tailwind et PostCSS
RUN npm install tailwindcss postcss autoprefixer

# Copie le reste de l'app
COPY . .

# Initialisation de Tailwind si nécessaire
RUN npx tailwindcss init

# Build du projet Astro
RUN npm run build

# Étape 2 : Image minimale pour le déploiement (production)
FROM node:23-slim AS runner

WORKDIR /app

# Copie seulement ce qui est nécessaire au runtime
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./

# Astro en mode preview sur le port 8080
EXPOSE 8080
CMD ["npx", "astro", "preview", "--port", "8080"]
