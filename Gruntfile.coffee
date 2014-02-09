module.exports = (grunt)->
  # Project configuration.
  grunt.initConfig {
    pkg: grunt.file.readJSON 'package.json'
    uglify:{
      options:{
        banner:'/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %>*/\n'
        report:'min'
      }
      build:{
        src:'js/base.js'
        dest:'js/base.min.js'
      }
    }
  }
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.registerTask 'default', ['uglify']