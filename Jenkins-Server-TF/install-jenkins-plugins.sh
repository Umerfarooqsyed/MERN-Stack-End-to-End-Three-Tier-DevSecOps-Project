#!/bin/bash


# Load .env
export $(grep -v '^#' .env | xargs)

# run thIs onn jenkins master node and adjust the  variable values accordinglyyy


CLI_PATH="/tmp/jenkins-cli.jar"
USER="Umer"


# --- Download CLI ---
if [ ! -f "$CLI_PATH" ]; then
    echo "Downloading jenkins-cli.jar..."
    wget "$JENKINS_URL/jnlpJars/jenkins-cli.jar" -O "$CLI_PATH"
fi

# --- Plugins List (IDs) ---
PLUGINS=(
  aws-credentials
  pipeline-aws         # put correct plugin id
  terraform
)

# --- Install Plugins ---
echo "Installing plugins..."
for PLUGIN in "${PLUGINS[@]}"
do
    echo "Installing: $PLUGIN"
    java -jar "$CLI_PATH" -s "$JENKINS_URL" -auth "$USER:$JENKINS_TOKEN" install-plugin "$PLUGIN" -deploy

    if [ $? -ne 0 ]; then
        echo "❌ Failed installing $PLUGIN"
        exit 1
    fi
done

# --- Restart Jenkins ---
echo "Restarting Jenkins..."
java -jar "$CLI_PATH" -s "$JENKINS_URL" -auth "$USER:$JENKINS_TOKEN" safe-restart
