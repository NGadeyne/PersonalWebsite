# Étape 1 : Choisir l'image de base
FROM node:22-slim AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier package.json et package-lock.json (si présents) pour les dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier tout le reste des fichiers de l'application
COPY . .

# Étape 2 : Construire l'application Astro
RUN npm run build

# Étape 3 : Préparer l'environnement de production
FROM node:22-slim

# Définir le répertoire de travail pour l'exécution
WORKDIR /app

# Copier les fichiers buildés depuis l'étape de build
COPY --from=build /app/dist /app/dist

# Installer uniquement les dépendances nécessaires pour la production
COPY package*.json ./
RUN npm install --production

# Exposer le port que l'application va utiliser
EXPOSE 8080

# Commande pour démarrer l'application en mode "preview" (production)
CMD ["npm", "run", "start"]
