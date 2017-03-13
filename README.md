# Avantlink Exercise #

## Installation ##

Clone or download repo.

**Requirements**

- mongodb
- nodejs

*Avantlink Exercise* uses mongodb, so you will need mongodb installed.  

**Install mongodb**

- [download & install](https://www.mongodb.com/download-center#community)

- if you are on a mac and have homebrew, run:

```
brew install mongodb
mkdir -p /data/db
```

- Once mongodb is installed, no configuration is required.  I'm running off the defaults (db: test)

**Run the following:**

```
cd /into/avantlink-exercise
npm install
```

```
mongod
```

And in a new instance:
```
node start
```

. . . and you're off to the races!

## Description ##

Some points of interest:

- *Avantlink Exercise* uses portions of the MEAN stack for speed and convenience of development.  This means that the api is node-based, as opposed to PHP.  Normally, I would use a PHP api as prescribed in the instructions, but I wanted to get something in your hands quickly.  If you would like a PHP version, as well, I can do this, but it would require more time &ndash; Up to you.

- I used [Wirestorm](https://github.com/jaderigby/wirestorm2) to aid in quickly prototyping the layout and portions of the ui.  Wirestorm is a project conceptualized, designed and created &ndash; from the ground up &ndash; by me.
It's main focus is on wireframeing new sites, concepts/ideas, and workflows.  Because of this, it is intentionally presented at a low fidelity.  (Incidentally, I am in the process of producing a version of Wirestorm that can go from conceptualization to production-ready; it is open-source)

- I focused mainly on functionality, ux, and behavior.  Validation is limited to mainly components as demonstrated from your mockups.

Hope this helps! :)