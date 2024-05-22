# Utiliser une image de base officielle Python avec Python 3.6 ou supérieur
FROM python

# Définir les versions de Terraform et Packer
ENV TERRAFORM_VERSION=1.8.0
ENV PACKER_VERSION=1.10.0

# Installer Terraform
RUN apt-get update && apt-get install -y wget unzip \
    && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Installer Packer
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && rm packer_${PACKER_VERSION}_linux_amd64.zip

# Copier le fichier requirements.txt dans le conteneur
COPY requirements.txt .

# Installer les paquets Python spécifiés dans requirements.txt
RUN  apt install pipx sshpass -y
RUN pipx ensurepath
RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pipx install --include-deps ansible

# Définir Terraform comme point d'entrée
ENTRYPOINT ["terraform"]

# Commande par défaut pour afficher la version de Terraform
CMD ["--version"]
