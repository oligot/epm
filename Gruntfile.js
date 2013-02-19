var path = require('path');
var spawn = require('child_process').spawn;
var _ = require('underscore');

module.exports = function(grunt) {

  grunt.registerMultiTask('compile', 'Eiffel compilation', function() {
    var done = this.async();
    var workbench = grunt.option('workbench') || false;
    var options = this.options({
      ecf: path.basename(process.cwd()) + '.ecf',
      env: {}
    });
    if (this.target === 'ise') {
      var name = 'ec';
      if (workbench) {
        var args = [];
      } else {
        var args = ['-finalize'];
      }
      args.push('-config', options.ecf, '-c_compile');
    } else {
      var name = 'gec';
      if (workbench) {
        var args = [];
      } else {
        var args = ['--finalize'];
      }
      args.push('--catcall=no', options.ecf);
    }

    grunt.log.writeln('Launching ' + name + ' ' + args.join(' ') + '...');
    var env = _.extend(options.env, process.env);
    var ec = spawn(name, args, {
      env: env
    });

    ec.stdout.on('data', function (data) {
      process.stdout.write(data);
    });

    ec.stderr.on('data', function (data) {
      process.stdout.write(data);
    });

    ec.on('exit', function (code) {
      if (code === 0) {
        grunt.log.ok();
        done();
      } else {
        done(false);
      }
    });
  });

  grunt.initConfig({
    clean: {
      ise: ['EIFGENs'],
      ge: ['epm', 'epm.h', 'epm.sh', 'epm1*']
    },
    compile: {
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
  grunt.registerTask('default', ['clean:ise', 'compile:ise']);
  grunt.registerTask('ge', ['clean:ge', 'compile:ge']);
};
