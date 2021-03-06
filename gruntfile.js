module.exports = function(grunt) {
    // Project Configuration
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        watch: {
            jade: {
                files: ['app/views/**'],
                options: {
                    livereload: true
                }
            },
            js: {
                files: ['public/src/scripts/**/*.js', 'app/**/*.js'],
                tasks: ['jshint', 'copy:js'],
                options: {
                    livereload: true
                }
            },
            coffee: {
                files: 'public/src/scripts/**/*.coffee',
                tasks: ['coffee'],
                options: {
                    livereload: true
                }
            },
            sprite: {
                files: 'public/src/sprites/*',
                tasks: ['sprite'],
                options: {
                    livereload: true
                }
            },
            html: {
                files: ['public/src/*.html'],
                tasks: ['copy:html'],
                options: {
                    livereload: true
                }
            },
            css: {
                files: ['public/src/styles/**'],
                options: {
                    livereload: true
                }
            }
//            sass: {
//                files: ['public/src/sass/**/*.scss'],
//                tasks: ['compass:dev'],
//                options: {
//                    livereload: true
//                }
//            }
        },
        copy: {
            js: {
                files: [
                    {
                        expand: true,
                        cwd: 'public/src/scripts',
                        src: '**/*.js',
                        dest: 'public/build/dev/scripts'
                    }
                ]
            },
            html: {
                files: [
                    {
                        expand: true,
                        cwd: 'public/src',
                        src: '*.html',
                        dest: 'public/build/dev'
                    }
                ]
            },
            lib: {
                files: [
                    {
                        expand: true,
                        cwd: 'public/src/lib',
                        src: [
                            'jquery/jquery.js',
                            'requirejs/require.js',
                            //'lazy/dist/lazy.js',
                            'underscore/underscore.js',
                            //'newton/newton.js',
                            'box2d-html5/**/*.js',
                            'requirejs-plugins/src/*.js'
                        ],
                        dest: 'public/build/dev/lib'
                    }
                ]
            },
            css: {
                files: [
                    {
                        expand: true,
                        cwd: 'public/src/styles',
                        src: '**/*.css',
                        dest: 'public/build/dev/styles'
                    }
                ]
            }
        },
        coffee: {
            options: {
                sourceMap: true
            },
            compile: {
                expand: true,
                cwd: 'public/src/scripts',
                src: '**/*.coffee',
                dest: 'public/build/dev/scripts',
                ext: '.js'
            }
        },
        jshint: {
            all: ['gruntfile.js', 'public/src/scripts/**/*.js', 'test/**/*.js', 'app/**/*.js']
        },
        nodemon: {
            dev: {
                options: {
                    file: 'server.js',
                    args: [],
                    ignoredFiles: ['README.md', 'node_modules/**', '.DS_Store'],
                    watchedExtensions: ['js'],
                    watchedFolders: ['app', 'config'],
                    debug: true,
                    delayTime: 1,
                    env: {
                        PORT: 3000
                    },
                    cwd: __dirname
                }
            }
        },
        concurrent: {
            tasks: ['compass:watch', 'nodemon', 'watch'],
            options: {
                limit: 4,
                logConcurrentOutput: true
            }
        },
        mochaTest: {
            options: {
                reporter: 'spec'
            },
            src: ['test/**/*.js']
        },
        sprite: {
            all: {
                src: 'public/src/sprites/*.png',
                destImg: 'public/build/dev/spritesheet.png',
                destCSS: 'public/build/dev/spritesheet-map.json',
                imgPath: 'spritesheet.png',
                algorithm: 'binary-tree'
            }
        },
        compass: {
            dev: {
                options: {
                    sassDir: 'public/src/sass',
                    cssDir: 'public/build/dev/styles'
                }
            },
            watch: {
                options: {
                    debugInfo: true,
                    sassDir: 'public/src/sass',
                    cssDir: 'public/build/dev/styles',
                    watch: true
                }
            }
        }
    });

    //Load NPM tasks 
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-mocha-test');
    grunt.loadNpmTasks('grunt-nodemon');
    grunt.loadNpmTasks('grunt-concurrent');
    grunt.loadNpmTasks('grunt-spritesmith');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-compass');

    //Making grunt default to force in order not to break the project.
    grunt.option('force', true);

    //Default task(s).
    grunt.registerTask('build', ['compass:dev', 'sprite', 'jshint', 'coffee', 'copy']);
    grunt.registerTask('default', ['build', 'concurrent']);

    //Test task.
    grunt.registerTask('test', ['mochaTest']);
};
