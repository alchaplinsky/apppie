"use strict"
module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig
    # pkg
    pkg: grunt.file.readJSON('package.json')

    # dirs
    dirs:
      cssTmp: "tmp/stylesheets"
      distFolder: "dist"
      dist: "<%= dirs.distFolder %>/<%= pkg.version %>"

    # Before generating any new files, remove any previously-created files.
    clean:
      tests: ["tmp", "<%= dirs.distFolder %>"]

    # concat
    concat:
      options:
        stripBanners: true
        banner: '/*! <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %> | <%= pkg.licenses[0].type %> */\n'
      css:
        src: [
          "<%= dirs.cssTmp %>/mixins/all.css",
          "<%= dirs.cssTmp %>/base/all.css",
          "<%= dirs.cssTmp %>/typography.css",
          "<%= dirs.cssTmp %>/library.css"
        ]
        dest: "<%= dirs.dist %>/css/<%= pkg.name %>.css"

    # min css
    cssmin:
      combine:
        files:
          "<%= dirs.dist %>/css/<%= pkg.name %>.min.css": "<%= dirs.dist %>/css/<%= pkg.name %>.css"

    # copy
    copy:
      sass:
        files: [
          expand: true
          cwd: "src/stylesheets"
          src: ['**/*.sass']
          dest: "<%= dirs.dist %>/sass"
        ]

    # sass options
    sass:
      dist:
        files:[
          expand: true
          cwd: "src/stylesheets"
          src: ['**/*.sass']
          dest: "<%= dirs.cssTmp %>"
          ext: ".css"
        ]

    #gzip assets 1-to-1 for production
    compress:
      release:
        options:
          mode: "zip"
          archive: "<%= dirs.distFolder %>/<%= pkg.name %>-<%= pkg.version %>.zip"
        files: [
          expand: true
          cwd: "<%= dirs.dist %>"
          src: ['**/*']
          dest: "<%= pkg.name %>-<%= pkg.version %>/"
        ]


    # watch
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
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-compress"

  # Whenever the "test" task is run, first clean the "tmp" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask "test", ["clean", "coffee"]

  # dev
  grunt.registerTask "dev", ["clean", "sass", "concat", "cssmin", "copy"]

  # release
  grunt.registerTask "release", ["dev", "compress"]

  # By default, lint and run all tests.
  grunt.registerTask "default", ["watch"]