# repository-template

SoundCloud's template for GitHub repository generation.

This repository serves as scaffolding for new repositories. [Take a look at what this means](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-on-github/creating-a-repository-from-a-template).

### Ok, now what?

We recommend the following steps immediately after checking out the new repository generated by the template:

1. Edit the `catalog-info.yaml` file to include as much information as possible about the state of your project.
2. Edit the `manifest.json` file with correct information on its fields, especially `name` and `owner`. You can rely on [sc-tools](https://go.soundcloud.org/sc-tools) to validate it with `sc manifest validate`.
3. Replace this `README` file.

### FAQ

#### How did this happen?

When terraforming new repositories, the YAML file that defines the repository access permissions includes properties to set the templating source. Read [the documentation](https://eng-doc.soundcloud.org/job-aids/managing-github-repositories/) for full information on how to manipulate it.
