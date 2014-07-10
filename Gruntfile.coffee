module.exports = (grunt) ->

  "use strict"

  require("load-grunt-tasks") grunt
  grunt.loadNpmTasks "grunt-wiredep"

  grunt.initConfig

    # Project settings
    lightbox:
      src: "src"
      test: "test"
      dist: "dist"
      dummy: "dummy"

    pkg: grunt.file.readJSON("package.json")
    banner: "/*!\n" + " * Lightbox for Bootstrap 3 by @ashleydw\n" + " * https://github.com/ashleydw/lightbox\n" + " *\n" + " * License: https://github.com/ashleydw/lightbox/blob/master/LICENSE\n" + " */"

    
    wiredep:
      test:
        src: ["<%= lightbox.test %>/dummy/index.html"]


    coffee:
      dist:
        files: [
          expand: true
          cwd: "<%= lightbox.src %>"
          src: "*.coffee"
          dest: ".tmp/scripts"
          ext: ".js"
        ]
      test:
        files: [
          expand: true
          cwd: "test"
          src: "*.coffee"
          dest: ".tmp/test"
          ext: ".js"
        ]
      compile:
        files:
          "dist/ekko-lightbox.js": "ekko-lightbox.coffee"


    clean:
      server: ".tmp"


    concurrent:
      test: [
        "coffee:dist"
        "coffee:test"
      ]


    connect:
      options:
        hostname: "localhost"
        livereload: 35729
      test:
        options:
          port: 9001
          base: [
            ".tmp"
            "test"
            "<%= lightbox.src %>"
            "<%= lightbox.test %>"
          ]


    recess:
      options:
        compile: true

      css:
        files:
          "dist/ekko-lightbox.css": "ekko-lightbox.less"

      css_min:
        options:
          compress: true

        files:
          "dist/ekko-lightbox.min.css": "ekko-lightbox.less"

    uglify:
      js:
        files:
          "dist/ekko-lightbox.min.js": "dist/ekko-lightbox.js"

    usebanner:
      dist:
        options:
          banner: "<%= banner %>"

        files:
          src: ["dist/ekko-lightbox.min.js"]

    watch:
      coffee:
        files: ["ekko-lightbox.coffee"]
        tasks: ["dist"]


    # Test settings
    karma:
      unit:
        configFile: "karma.conf.coffee"
        singleRun: true


    bump:
      options:
        files: [
          "package.json"
          "bower.json"
        ]
        updateConfigs: ["pkg"]
        commit: true
        commitMessage: "Release v%VERSION%"
        commitFiles: [
          "package.json"
          "bower.json"
        ]
        createTag: true
        tagName: "v%VERSION%"
        tagMessage: "Version %VERSION%"
        push: false

  grunt.loadNpmTasks "grunt-banner"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-recess"
  grunt.loadNpmTasks "grunt-bump"

  grunt.registerTask "dist", [
    "coffee"
    "uglify"
    "recess"
    "usebanner"
  ]

  grunt.registerTask "test", [
    "clean:server"
    "concurrent:test"
    "connect:test"
    "karma"
  ]

  grunt.registerTask "default", ["dist"]
  return
