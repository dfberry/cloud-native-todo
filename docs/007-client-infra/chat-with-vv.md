* Infra - implicit dependency 
    * Bicep - api module deployed first than others such as web
* provisioning for container app just creates container env
* deploy creates container app on container env
* Docker file
    * BUILD layer
    * NGINX layer - env variables when provisioning finished, for deployment to use
* Container apps versus SWA
    * run build before provisioning, AZD package
    * break dependency between where app is hosted and app itself - because some languages can run then pull app settings such as .NET
    * azure.yml service host value
        * Container app - Docker start uses env-config.js
            * update container with values we need, then container runs, first thing it runs is the window environment file
            * azd deploy on container calls package which calls build creates container pushes container to container
            * azd package just create a local tag for the image
        * SWA - no environment - more like storage - use CLI/GitHub action to build/merge - predeploy hook are for SWA
            * azd does double build with predeploy hook - azd package which calls npm build without environment, then azd provision, then before deployment call npm build again, then just deploy with SWA CLI - that we need hook before because of ordering 
* ENV from hooks
    * azd prepackage hook for client only
* ENV from Docker start
* Debug
    * azd provision - .azure has env
    * azd package - invoke Dockerfile and gives output in console
        * Update Dockerfile with echo statement in CMD
            `CMD ["/bin/sh", "-c", "echo $VITE_API_URL && /bin/entrypoint.sh -o /usr/share/nginx/html/env-config.js && nginx -g \"daemon off;\""]`
* Careful
    * if you run docker build on your own it won't have the environment variables