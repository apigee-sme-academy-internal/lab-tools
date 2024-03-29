# Lab Tools

This repo holds common tools that are used by lab creators while developing
the lab content itself.

The rendering of Google Docs to Qwiklabs Markdown format relies on [claat](https://github.com/googlecodelabs/tools/tree/main/claat).
Please follow the claat instructions on how to install it.

## How to use the tools


Clone the repo

```shell script
git clone https://github.com/apigee-sme-academy-internal/lab-tools.git
```

Add the bin directory into your path

```shell script
export PATH="$(pwd)/lab-tools/bin:$PATH"
```

## gdoc-2-markdown.sh

This script takes an existing Google Doc and converts it to the markdown
format used by Qwiklabs. The script itself uses the claat tool to do the
conversion.

Additionally, the script downloads and replaces images that the claat tool misses.


Example usage:

```shell script
gdoc-2-markdown.sh 1pMq49viVv0IF81GRIEoGnjeigfwUAmAZvaKbmNH_Syk enbl008-apigee-appmod-lab-2-implement-oauth-2-password-grant
```

The script does a few things:

1. Uses the claat tool to download the gdoc and convert it to markdown
2. Replaces the existing `instructions/en.md` from your lab with the `index.md` generated by claat
3. Replaces the contents of the `instructions/img` directory with the ones from claat.
4. Applies post-processing logic on the new `.md` file


### gdoc-2-markdown.sh - MD syntax highlighting

One of the post processing activities done by this tool is to enable syntax highlight in code blocks

To get syntax highlighting use the `!lang format` tag at the beginning of your code blocks within the Google Doc.

Here are some examples:

```shell script
!lang xml
<Sample>
  <Foo></Foo>
</Sample>
```

```shell script
!lang shel script
echo "hello world"
```

```shell script
!lang json
{
  "foo": "bar"
}
```

You can use any language tag that understood by Qwiklabs.

### gdoc-2-markdown.sh - MD Pass-through

Some features of Qwiklabs require the use special markdown tags.
From your Google Doc you can pass-through raw MD text using a code-block with special tags
at the beginning and the end.

Here is an example of how to pass-through Qwiklabs specific activity tracking

```shell script
!md-start
<ql-activity-tracking step=1>
    Check that Kubernetes secret was created
</ql-activity-tracking>
!md-end
```


## update-lab-instructions.sh


This script helps smooth out the workflow when updating lab instructions when using the Qwiklabs git flow.

The idea is that you simply work on the Google doc to make your changes.
Then, you use this script to update the local Git repo with the latest changes.

This is the usage:

```shell script
update-lab-instructions.sh /path/to/qwiklabs/repo lab-prefix gdoc-id
```

Here is example of how to use it:

First, make sure you clone the Qwiklabs git repo that has your lab:
```
git clone git@github.com:CloudVLab/gcp-enablement-content.git
```
Switch to the Qwiklabs repo

```shell script
cd gcp-enablement-content
```

Then, create a branch for your lab changes:
```
git checkout -b update_enbl007_lab origin/master
```

Then run the script to update instructions for one of the labs:
```shell script
update-lab-instructions.sh . enbl007 15hofQmOqNVO3IxquS3sAKDmUYJ5ju9Yq6l4gM7nCLpI
```

This will update the contents of:

```
gcp-enablement-content/labs/enbl007*/en.md
gcp-enablement-content/labs/enbl007*/img/*
```

Finally, inspect the content changes, create a new commit and push the branch.
```shell script
git add labs/enbl007*
git commit -m "Update enbl007 lab"
git push origin update_enbl007_lab
```