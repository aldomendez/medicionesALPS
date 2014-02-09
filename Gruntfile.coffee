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
        src:'js/dist.js'
        dest:'js/dist.min.js'
      }
    }
    concat:{
      dist:{
        src:[
          'vendor/jquery-2.1.0.min.js'
          'vendor/underscore-1.5.2.min.js'
          'vendor/nprogress.js'
          'vendor/Ractive.min.js'
          'js/base.min.js'
        ]
        dest:'js/dist.js'
      }
    }
  }
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.registerTask 'default', ['uglify']
  grunt.registerTask 'distrib', ['concat','uglify']