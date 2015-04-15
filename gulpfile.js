var Flbuild = require('flbuild')
	, exec = require('done-exec')
	, gulp = require('gulp')
	, fs = require('fs')

var flbuild = new Flbuild()
flbuild.setEnv('FLEX_HOME')
flbuild.setEnv('PROJECT_HOME', '.')
flbuild.setEnv('PLAYER_VERSION', '16.0')
flbuild.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/player/$PLAYER_VERSION')
flbuild.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/')
flbuild.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/mx/')
flbuild.addLibraryDirectory('$FLEX_HOME/frameworks/locale/en_US/')
flbuild.addLibraryDirectory('$PROJECT_HOME/libs/')
flbuild.addSourceDirectory('$PROJECT_HOME/src')

// namespace 별로 패키징 한다
gulp.task('ssen', function (done) {
	var build = flbuild.getLibraryCreator()

	build.setFilterFunction(function (file) {
		return file.class.indexOf('ssen.') === 0
			&& file.class.toLowerCase().indexOf('ssen.components') === -1
			&& file.class.toLowerCase().indexOf('showcase__') === -1
			&& file.class.toLowerCase().indexOf('_showcase_') === -1
			&& file.class.toLowerCase().indexOf('test__') === -1
	})


	build.createBuildCommand('$PROJECT_HOME/bin/ssenkit.swc', function (cmd) {
		cmd = cmd.replace('.exe', '.bat')
		console.log('gulpfile.js..()', cmd.length)
		fs.writeFileSync('compc.bat', cmd)
		console.log('gulpfile.js..()', cmd)
		exec(cmd).run(done)
	})
})

gulp.task('ssen-mxchart', function (done) {
	var build = flbuild.getLibraryCreator()

	build.setFilterFunction(function (file) {
		return file.class.indexOf('ssen.components.mxChartSupportClasses') === 0
	})

	build.createBuildCommand('$PROJECT_HOME/bin/ssen-mxchart.swc', function (cmd) {
		console.log(cmd)
		exec(cmd).run(done)
	})
})

gulp.task('ssen-mxgrid', function (done) {
})

gulp.task('ssen-sparkgrid', function (done) {
})