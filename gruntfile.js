module.exports = function(grunt) {
    // Project Configuration
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        watch: {
            jade: {
                files: ['app/views/**'],
                options: {
                    livereload: true,
                }
            },
            js: {
                files: ['public/dev/scripts/**/*.js', 'app/**/*.js'],
                tasks: ['jshint', 'copy:js'],
                options: {
                    livereload: true,
                }
            },
            coffee: {
                files: 'public/dev/scripts/**/*.coffee',
                tasks: ['coffee'],
                options: {
                    livereload: true,
                }                
            },
            sprite: {
                files: 'public/dev/sprites/*',
                tasks: ['sprite'],
                options: {
                    livereload: true,
                }                
            },
            html: {
                files: ['public/dev/**/*.html'],
                tasks: ['copy:html'],
                options: {
                    livereload: true,
                }
            },
            css: {
                files: ['public/dev/styles/**'],
                options: {
                    livereload: true
                }
            }
        },
        copy: {
            js: {
                files: [
                    {
                        expand: true,
                        cwd: 'public/dev/scripts',
                        src: '**/*.js',
                        dest: 'public/dev/build/scripts'
                    }
                ]
            },
            html: {
                files: [
                    {
                        expand: true,
                        cwd: 'public/dev',
                        src: '*.html',
                        dest: 'public/dev/build'
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
                cwd: 'public/dev/scripts',
                src: '**/*.coffee',
                dest: 'public/dev/build/scripts',
                ext: '.js'
            }
        },
        jshint: {
            all: ['gruntfile.js', 'public/dev/scripts/**/*.js', 'test/**/*.js', 'app/**/*.js']
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
            tasks: ['nodemon', 'watch'], 
            options: {
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
        		src: "public/dev/sprites/*.png",
        		destImg: "public/dev/build/spritesheet.png",
        		destCSS: "public/dev/build/spritesheet.json",
        		imgPath: "../build/spritesheet.png",
        		algorithm: "binary-tree",
    	    }
    	},
        build: {
            tasks: ['sprite', 'coffee', 'copy']
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

    //Making grunt default to force in order not to break the project.
    grunt.option('force', true);

    //Default task(s).
    grunt.registerTask('default', ['jshint', 'concurrent']);

    //Test task.
    grunt.registerTask('test', ['mochaTest']);
};
