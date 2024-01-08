# How to deploy the new static web front-end client to an Azure container app

In order to provision and deploy the client to a container app, several steps have to take place:

1) Create the new service in the azure.yml.
2) Create the infra structure in the infra subfolder to create the new container
3) Build the code with the backend URI so the client API requests go to the correct server
4) Deploy the code 

This seems pretty straight forward but how do you get the API URI and when is it available in the lifecycle of the Azure Developer CLI?

For container apps, you have 2 choices:

1) Inject the variable in the container at start time. There has to be some script as part of container start up that takes those values and makes them available to the front end. The example I've seen adds the values to a WINDOW.ENV_CONFIG which is loaded as a script from the Index.html. There are several reasons I wouldn't do this but they boil down to security risks through human error. You might add information through environment variables that you don't want exposed on the client.

2) Idiomatic build with environment variables. Static front-end frameworks such as Create React App or Vite expect the environment variables to be available at build time either through direct access of the environment or through a file such as .env. For project deployed with Azure Developer CLI, the environment variables aren't available in the Dockerfile, but rather at container startup time. In order to get the variables into the build, use an Azure Developer hook such as post-provision or pre-deployment, to get those values with `azd env get-values` and insert them into a `.env` file which is copied into with the Dockerfile, then the build proceeds. The Dockerfile only copies over the generated static files. The `.env` itself isn't copied into the final container image and isn't available publicly through the website. If you expose secrets via the `.env`, those values aren't on the container unless you specifically pull them into your source code. 

    You can't have this step be a prebuild in the package.json because Azure Developer CLI calls it in the package phase, which happens before provisioning. 