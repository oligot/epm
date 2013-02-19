var spawn = require('child_process').spawn;

module.exports = function(grunt) {

  grunt.registerMultiTask('compile', 'Eiffel compilation', function() {
    var done = this.async();
    var options = this.options({
      workbench: false,
      compiler: 'ise'
    });
    if (options.compiler === 'ise') {
      var name = 'ec';
      if (options.workbench) {
        var args = [];
      } else {
        var args = ['-finalize'];
      }
      args.push('-config', options.ecf, '-c_compile');
    } else {
      var name = 'gec';
      if (options.workbench) {
        var args = [];
      } else {
        var args = ['--finalize'];
      }
      args.push('--catcall=no', options.ecf);
    }

    process.env.EIFFEL_LIBRARY = process.cwd() + '/eiffel_library';
    process.env.GOBO = process.env.EIFFEL_LIBRARY + '/gobo';
    grunt.log.writeln('Launching ' + name + ' ' + args.join(' ') + '...');
    var ec = spawn(name, args);

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
        ecf: 'epm.ecf'
      },
      ise: {
        options: {
          workbench: true
        }
      },
      ge: {
        options: {
          compiler: 'ge'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.registerTask('default', ['clean:ise', 'compile:ise']);
  grunt.registerTask('ge', ['clean:ge', 'compile:ge']);
};
