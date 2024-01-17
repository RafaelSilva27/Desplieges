#!/bin/bash

# Actualizar la lista de paquetes del sistema
apt update

# Instalar el paquete openjdk-17-jdk
 apt install -y openjdk-17-jdk

# Verificar si el usuario 'tomcat' ya existe antes de intentar crearlo
if id "tomcat" >/dev/null 2>&1; then
    echo "El usuario 'tomcat' ya existe. No es necesario crearlo de nuevo."
else
    # Agregar un nuevo usuario llamado 'tomcat' con las opciones especificadas
    sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat

    # Explicación de las opciones:
    # -m: Crea el directorio de inicio del usuario si no existe
    # -d /opt/tomcat: Establece el directorio de inicio en /opt/tomcat
    # -U: Crea un grupo con el mismo nombre que el usuario y hace que el usuario sea el propietario del grupo
    # -s /bin/false: Establece el shell de inicio de sesión en /bin/false, lo que impide que el usuario inicie sesión
fi

# Cambiar al directorio /tmp
cd /tmp

# Descargar Apache Tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz -O tomcat.tar.gz

# Descomprimir y mover Tomcat a /opt/tomcat
tar xzvf tomcat.tar.gz -C /opt/tomcat --strip-components=1

# Cambiar la propiedad del directorio a tomcat:tomcat
chown -R tomcat:tomcat /opt/tomcat/

# Dar permisos de ejecución a los scripts en /opt/tomcat/bin
chmod -R u+x /opt/tomcat/bin

# Agregar roles y usuarios al archivo tomcat-users.xml
echo -e '<tomcat-users xmlns="http://tomcat.apache.org/xml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd">\n  <role rolename="manager-gui" />\n  <user username="manager" password="secret" roles="manager-gui" />\n  <role rolename="admin-gui" />\n  <user username="admin" password="secrete" roles="manager-gui,admin-gui" />\n</tomcat-users>' | sudo tee /opt/tomcat/conf/tomcat-users.xml > /dev/null

# Comentar la etiqueta <Valve> en el archivo context.xml de la aplicación manager
sudo sed -i '/<Valve/,/<\/Valve>/ s/^/<!--/' /opt/tomcat/webapps/manager/META-INF/context.xml
sudo sed -i '/<Valve/,/<\/Valve>/ s/$/-->/' /opt/tomcat/webapps/manager/META-INF/context.xml

# Obtener la ruta del directorio de instalación de Java (JAVA_HOME)
JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")

# Crear el archivo de servicio de systemd para Tomcat
echo -e "[Unit]\nDescription=Tomcat\nAfter=network.target\n\n[Service]\nType=forking\nUser=tomcat\nGroup=tomcat\nEnvironment=\"JAVA_HOME=$JAVA_HOME\"\nEnvironment=\"JAVA_OPTS=-Djava.security.egd=file:///dev/urandom\"\nEnvironment=\"CATALINA_BASE=/opt/tomcat\"\nEnvironment=\"CATALINA_HOME=/opt/tomcat\"\nEnvironment=\"CATALINA_PID=/opt/tomcat/temp/tomcat.pid\"\nEnvironment=\"CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC\"\n\nExecStart=/opt/tomcat/bin/startup.sh\nExecStop=/opt/tomcat/bin/shutdown.sh\n\nRestartSec=10\nRestart=always\n\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/tomcat.service > /dev/null

# Recargar los servicios de systemd
sudo systemctl daemon-reload

# Habilitar el servicio Tomcat para que se inicie en el arranque
sudo systemctl enable tomcat.service