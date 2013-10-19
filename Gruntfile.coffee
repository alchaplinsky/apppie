"use strict"
module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig
    # pkg
    pkg: grunt.file.readJSON('package.json')

    # Before generating any new files, remove any previously-created files.
    clean:
      tests: ["tmp/bare", "tmp/default", "tmp/join"]

    # Unit tests.
    nodeunit:
      tests: ["test/*_test.js"]

    # sass options
    sass:
      dist:
        files:[
          expand: true
          cwd: "src/stylesheets"
          src: ['**/*.sass']
          dest: "build/stylesheets"
          ext: ".css"
        ]

    watch:
      css:
        files: '**/*.sass'
        tasks: ['sass']


  # Actually load this plugin's task(s).
  #grunt.loadTasks "tasks"

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-watch"

  # Whenever the "test" task is run, first clean the "tmp" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask "test", ["clean", "coffee", "nodeunit"]

  # By default, lint and run all tests.
  grunt.registerTask "default", ["watch"]