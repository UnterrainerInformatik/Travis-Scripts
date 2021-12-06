[![license](https://img.shields.io/github/license/unterrainerinformatik/MyStromRestApiCSharp.svg?maxAge=2592000)](http://unlicense.org)  [![Twitter Follow](https://img.shields.io/twitter/follow/throbax.svg?style=social&label=Follow&maxAge=2592000)](https://twitter.com/throbax)  

# General

You may copy, use or rewrite every single file within this project to your hearts content.  
In order to get help with basic GIT commands you may try [the GIT cheat-sheet][coding] on our [homepage][homepage].  

If you want to contribute to our repository (push, open pull requests), please do so.  



# Travis-Scripts

Scripts and manuals to help configure Travis for various builds and build targets.

> **If you like this repo, please don't forget to star it.**
> **Thank you.**



## Description

This project offers some support for Travis-CI script files because it can be hard to get the scripting up and running. With this solution it's possible to do some stuff by configuration only.

It was created as the need to simplify Travis-CI setup for our project since there are quite a few and we rather adapt a single repository than 20 when some intricacies of Travis-CI should change.

Of course it's not nearly as flexible as scripting the `.travis.yml` file yourself, but then it never can be.

Take this 'as it is' and configure the builds using Travis-CI environment variables set in the Travis-CI GUI, or use it as reference for your own script files.

Here is what will happen:

1. Make a change in your code
2. Push to a develop branch
3. Make a pull-request to master
4. Accept the pull-request
5. Merge the pull-request
6. GitHub Action bumps version, commits new tag
7. Travis gets triggered, starts build
8. Travis gets version from git-tag
9. Travis builds your project
10. Travis runs the tests of your project
11. Travis deploys your project



### GitHub Action

When you push a change to the master of your repository, a GitHub action is triggered ([bump-version](bump-version)). That action pumps the version of your branch, tags it and commits the tag.
That tag can later be used to determine the version-number of your build.

In the current configuration it will bump the patch-version unless your commit message contains `#minor` or `#major`.

To configure the action, read the documentation of the action.



## Supported Systems

This project has several sub directories containing the scripts to compile a specific system (e.g. .NET or Java).

Every `.travis.yml` file in those folders has an explanation for the environment-variables it's able to understand and react upon. Follow those instructions to control the behavior of the build-script.



### .NET

The `.NET` folder contains scripts to compile your C# .NET project (a Visual Studio Solution) and, if you like, to build a nuget package that is deployed (pushed) to nuget.org if everything runs fine.

If you don't like a nuget package to be published, just don't declare the variable `NUGET` or set it to `false`.
Then you may omit setting the other variables starting with `NUGET_` as well.

#### MONOGAME Notes

If you're using the MonoGame switch, then you have a few extra options.

When using SpriteFonts, the build-system of MonoGame has to have the font installed on your system (except if you use the SpriteFonts with an image-map).
So there has to be a directory `/Travis-Install` in your build where all your `TTF` fonts reside.
The script will install them on the builder before running the build.

## Usage

1. Choose the system you want to compile
   If you want to compile a .NET project and possibly deploy a nuget package in the process, then choose the `.NET` folder.
   
2. Take the `.travis.yml` file from out of that folder and copy it to the root of your repository.
   (In the .NET folder, take the `.travis-core.yml` or `.travis-mono.yml` and rename it to `.travis.yml` depending on what you want to build (a core-project or standard .NET framework)).

3. Make a root-directory `Travis-Install` where you can put assets that need to be installed on the builder before starting the build (fonts, so it can create the spritefont from out of that, for example).

4. Go to the GitHub page of your repository and click the `Actions` button:
   ![github actions select](https://github.com/UnterrainerInformatik/Travis-Scripts/raw/master/docs/github-actions-select.png)

5. Click `Set up a Workflow yourself` in the top right corner:
   ![gitbub actions self](https://github.com/UnterrainerInformatik/Travis-Scripts/raw/master/docs/github-actions-self.png)

6. Copy the contents of the file `github-action.yml` in the root of this repository into the text-editor on your screen.

7. Commit the changes to the master branch to activate the action:
   ![github actions commit](https://github.com/UnterrainerInformatik/Travis-Scripts/raw/master/docs/github-actions-commit.png)

8. Now you still have to push a starting-tag to the `master` (not `develop`; that branch remains untagged).
   You can do this using the GitHub UI (Tag <=> Release in GitHub UI) or command-line git.

   ```bash
   git tag 1.0.0
   git push origin 1.0.0
   ```

9. Now to Travis-CI and log in.

10. Connect it to your GitHub account, if you didn't already do that.

11. Add your GitLab repository:
      ![travis add repo](https://github.com/UnterrainerInformatik/Travis-Scripts/raw/master/docs/travis-add-repo.png)

12. Configure the build by setting the Travis Environment Variables:
    ![travis environment variables](https://github.com/UnterrainerInformatik/Travis-Scripts/raw/master/docs/travis-environment-variables.png)

13. The next push to master should trigger the build now.



## Deployment (Java, npm)

In order to deploy your container correctly, you have to have a `./deploy` directory in your repository.

Within that directory you should have your `docker-compose.yml` file.

All the contents of that directory gets copied to the deployment-server (into the deployment directory there).

The deployment-directory on the target server is `/app/deploy/$REGISTRY_PROJECT` and the directory where it will save all the data to, if it saves data at all, is `/app/data/$REGISTRY_PROJECT`.

All of that happens in the script `deploy.sh` located in this project here.

Just copy and adapt the files in the `/deploy` directory.



## Passing Variables

When passing variables we have to consider the different kind of deployments since we want to serve the specific values to each of them.

Internally the techniques used to manipulate environment variables are:

```bash
#######################################
# Export all values
set -a

VAR=value
# or
. ./.env

set +a

#######################################
# Expand variables using current values
envsubst < inputfile.txt | tee outputfile.txt
```



### Staging Deployment (Java, npm)

The staging build is the standard-deployment. You can also use that one as your production deployment and leave the rest alone.

The problem with this deployment is that it's visible for everyone to see on travis and in the build logs. So we want to mask most of the variables passed to this build using the travis settings.

#### set-deployment-env.sh

This file is used to let you pass environment variables to the `.env` file and therefore automatically to the `docker-compose.yml` file that is run later on.

Here is an example:

```bash
#!/usr/bin/env bash

# Variables defined in this file will be used in the docker-compose.yml file
# by being copied to the .env file.
# So this is the place where to transfer the CI-variables to docker-compose.

DB_PASSWORD=$DB_PASSWORD
DB_ROOT_PASSWORD=$DB_ROOT_PASSWORD
OVERMIND_MEDIOLA_TOKEN=$OVERMIND_MEDIOLA_TOKEN
OVERMIND_SMTP_USER=$OVERMIND_SMTP_USER
```



### Production Deployment (Java, npm)

This deployment is done AFTER the staging deployment has run and should be done using sh-scripts on some server of yours. You may trigger those using crontab later on, but you already know all that, so here your go.

The problem with this deployment is that we have to include ways that allow you to change the variables AFTER the build has run and deployed the staging system. So we have to provide some entry-points where you can script some changes into your own deploy.sh script you choose to run for the production deployment.

### Java

No problem here. We only have to consider environment variables that end up being in used in the `deploy.sh` script and in the `docker-compose.yml` file.

You can do that by just substituting the `docker-compose.yml` file with one that has all the variables substituted by values you see fit for this production. They are visible on the deployment-machine anyway.

### npm

You can adapt the file `config.js` to get variables into your node-container.

In your JavaScript you can reference them using this class:

```javascript
# env.ts
declare global {
  interface Window {
    config: object;
  }
}

class Env {
  private static instanceField: Env

  public static getInstance () {
    if (!this.instanceField) {
      this.instanceField || (this.instanceField = new Env())
    }
    return this.instanceField
  }

  public get (key: string, defaultValue = ''): string {
    if (window.config && window.config[`${key}`] !== undefined) {
      const value = window.config[`${key}`]
      console.log('CONFIG - Found [' + key + '] in config.js. Value is [' + value + ']')
      return value
    }

    if (process.env && process.env[`VUE_APP_${key}`] !== undefined) {
      // get env var value
      const value = process.env[`VUE_APP_${key}`]
      console.log('CONFIG - Found [' + key + '] in process.env. Value is [' + value + ']')
      return value
    }
    console.log('CONFIG - Key [' + key + '] not found. Default is [' + defaultValue + ']')
    return defaultValue
  }
}

export const singleton = Env.getInstance()

```

Usage:

```javascript
state: () => ({
    host: env.get('KEYCLOAK_HOST', 'https://keycloak.blah.tld/auth'),
    // Without default value:
    //host: env.get('KEYCLOAK_HOST'),
    realm: env.get('KEYCLOAK_REALM', 'Cms')
    ...
```

Here we have a problem with how the variables are passed into the node container. This is done at build-time. So any change later on will not change anything since the `config.js` file has already been put into the node-container.

To mitigate this, we just mount the file to the local file-system and you can change the `config.js` file later on in your production deployment script as you see fit.

The location of the `config.js` file on the target server you deploy to is the root of the deployment directory.

### General Information

The tags are for the master only. You should create a separate branch called `develop` where to put your changes and to create pull-requests to the `master` branch from.

The `develop` commits won't be tagged and excluded from deploying automatically.



# References



[homepage]: http://www.unterrainer.info
[coding]: http://www.unterrainer.info/Home/Coding
[github]: https://github.com/UnterrainerInformatik/Travis-Scripts
[bump-version]: https://github.com/anothrNick/github-tag-action