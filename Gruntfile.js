module.exports = function(grunt) {

  grunt.initConfig({
    clean: {
      ise: ['EIFGENs'],
      ge: ['epm', 'epm.h', 'epm.sh', 'epm1*']
    },
    eiffel: {
      options: {
        env: {
          EIFFEL_LIBRARY: process.cwd() + '/eiffel_library',
          GOBO: process.env.EIFFEL_LIBRARY + '/gobo'
        }
      },
      ise: {},
      ge: {}
    }
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-eiffel');
  grunt.registerTask('default', ['clean:ise', 'eiffel:ise']);
  grunt.registerTask('ge', ['clean:ge', 'eiffel:ge']);
};
