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



## Usage

1. Choose the system you want to compile
   If you want to compile a .NET project and possibly deploy a nuget package in the process, then choose the `.NET` folder.
   
2. Take the `.travis.yml` file from out of that folder and copy it to the root of your repository.

3. Go to the GitHub page of your repository and click the `Actions` button:
   ![github actions select](https://github.com/UnterrainerInformatik/Travis-Scripts/raw/master/docs/github-actions-select.png)
   
4. Click `Set up a Workflow yourself` in the top right corner:
   ![gitbub actions self](https://github.com/UnterrainerInformatik/Travis-Scripts/raw/master/docs/github-actions-self.png)

5. Copy the contents of the file `github-action.yml` in the root of this repository into the text-editor on your screen.

6. Commit the changes to the master branch to activate the action:
   ![github actions commit](https://github.com/UnterrainerInformatik/Travis-Scripts/raw/master/docs/github-actions-commit.png)

7. Now you still have to push a starting-tag to the master.
   You can do this using the GitHub UI (Tag == Release) or command-line git.

   ```bash
   git tag 1.0.0
   git push origin 1.0.0
   ```

8. Now to Travis-CI and log in.

9. Connect it to your GitHub account, if you didn't already do that.

10. Add your GitLab repository:
   ![travis add repo](https://github.com/UnterrainerInformatik/Travis-Scripts/raw/master/docs/travis-add-repo.png)

11. Configure the build by setting the Travis Environment Variables:
    ![travis environment variables](https://github.com/UnterrainerInformatik/Travis-Scripts/raw/master/docs/travis-environment-variables.png)

12. The next push to master should trigger the build now.





# References



[homepage]: http://www.unterrainer.info
[coding]: http://www.unterrainer.info/Home/Coding
[github]: https://github.com/UnterrainerInformatik/Travis-Scripts
[bump-version]: https://github.com/anothrNick/github-tag-action