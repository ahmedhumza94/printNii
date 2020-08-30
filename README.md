# printNii
A command line tool to print nifti file headers built in swift.

## **Installation**
1. Clone or fork a copy of the project repo to your local mac
2. From terminal navigate to the project repo
3. Using xcode command line tools (tested with dev tools packaged with xcode 11) run:

```
sudo xcodebuild install -scheme printNii -configuration Release DSTROOT=/
```

This will install printNii to the default directory of /usr/local/bin.

## **Usage**
```
USAGE: print-nii <file>

ARGUMENTS:
  <file>                  Nii filename 

OPTIONS:
  -h, --help              Show help information.
```

## Example
Input:
```
printNii ~/Desktop/test.nii
```

## Notes

* Currently does not support compressed (.nii.gz)
* To be available as a swift package in future updates
