# perl

Custom compiled perl for deriv.com

## compiling steps

```bash
VERSION=5.26.1 ./rebuild.sh
```

## compiling it with CI

1. enable CI test in your forked repo : 
   at https://github.com/username/perl/settings/actions set `Allow all actions and reusable workflows`
   and `Read and write permissions`. Don't forget to click `save` at both section.
2. Or create a new branch directly on binary-com/perl repo
3. create a branch whose name include a perl version `perl-x.yy.zz`, e.g. `upgrade/perl.5.38.2`

Then CI will download and compile perl and push it to your branch
