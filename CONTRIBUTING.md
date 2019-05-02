## Welcome to Public Sans!

We're so glad you're thinking about contributing to an 18F open source project! If you're unsure or afraid of anything, just ask or submit the issue or pull request anyways. The worst that can happen is that you'll be politely asked to change something. We appreciate any sort of contribution, and don't want a wall of rules to get in the way of that.

Before contributing, we encourage you to read our CONTRIBUTING policy (you are here), our LICENSE, and our README, all of which should be in this repository. If you have any questions, or want to read more about our underlying policies, you can consult the 18F Open Source Policy GitHub repository at https://github.com/18f/open-source-policy, or just shoot us an email/official government letterhead note to [18f@gsa.gov](mailto:18f@gsa.gov).

## SIL Open Font License v1.1

Public Sans is licensed under the [SIL Open Font License v1.1](http://scripts.sil.org/OFL)
To view the copyright and specific terms and conditions please refer to ofl.txt

By submitting a pull request, you are agreeing to comply
with this license.

## Running the specimen site locally
The specimen site runs on Jekyll and Node, powered by USWDS. The site-related files are distinct from the Public Sans source files and are kept in the following locations:

```
public-sans/
├── _data/
├── _includes/
├── _layouts/
├── _sass/
├── pages/
└── assets/

```

## Running code locally
After cloning the repo, navigate to the correct folder and install USWDS, Jekyll, and any necessary dependencies using:
```
npm start
```
Then, to run the site locally:
```
npm run serve
```
If all goes well, visit the site at http://localhost:4000.

USWDS assets are in `assets/uswds/fonts` and `assets/uswds/img`.

SASS files are kept in the `/_sass` directory. To watch for changes and recompile the styles, run:
```
npm run watch
```
