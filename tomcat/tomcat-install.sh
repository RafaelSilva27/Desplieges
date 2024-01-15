#!/bin/bash
sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat
sudo apt update
sudo apt install openjdk-17-jdk -y
sudo apt install default-jdk -y
cd /tmp
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.20/bin/apache-tomcat-10.0.20.tar.gz
sudo tar xzvf /tmp/apache-tomcat-10*tar.gz -C /opt/tomcat --strip-components=1
sudo chown -R tomcat:tomcat /opt/tomcat/
sudo chmod -R u+x /opt/tomcat/bin
sudo sed -i '/<\/tomcat-users>/i \
  <role rolename="manager-gui" /> \
  <user username="manager" password="pass" roles="manager-gui" /> \
  \<role rolename="admin-gui" /> \<user username="admin" password="pass" roles="manager-gui,admin-gui" />' /opt/tomcat/conf/tomcat-users.xml
sudo sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="127\\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1""/ s/^/<!--/;s/$/-->/' /opt/tomcat/webapps/manager/META-INF/context.xml
sudo sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="127\\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1""/ s/^/<!--/;s/$/-->/' /opt/tomcat/webapps/host-manager/META-INF/context.xml
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOL
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-1.17.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOL
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat
sudo ufw allow 8080
