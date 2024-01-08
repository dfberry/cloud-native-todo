* AZD package
    * npm build wihtout environment
    * Tag local client image
* AZD provision
    * creates Azure resources
        * API first
        * WEB implicit dependence on API in params
    * create registry and container environment (not container apps)
    * create environment variables
* AZD deploy
    * npm build again
    * creates container
    * pushed container
    * container starts with script to generate env-config.js pulled in via the HTML file