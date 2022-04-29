const { src, dest, series, parallel, watch } = require("gulp");
const uswds = require("@uswds/compile");

uswds.settings.version = 3;
uswds.paths.src.projectSass = "./site/_sass";
uswds.paths.dist.img = "./site/assets/uswds/img";
uswds.paths.dist.fonts = "./site/assets/uswds/fonts";
uswds.paths.dist.js = "./site/assets/uswds/js";
uswds.paths.dist.css = "./site/assets/css";
uswds.paths.dist.theme = "./site/_sass";

const WEBFONTS_SRC = "./fonts/webfonts";
const WEBFONTS_DEST = "./site/assets/fonts";

function copyWebfonts() {
  return src(`${WEBFONTS_SRC}/**/**`)
    .pipe(dest(WEBFONTS_DEST));
}

function watchWebfonts() {
  return watch(`${WEBFONTS_SRC}/**/*`, copyWebfonts);
};

exports.watch = series(
  copyWebfonts, 
  uswds.compile, 
  parallel(
    uswds.watch,
    watchWebfonts
  )
);

exports.compileIcons = uswds.compileIcons;
exports.copyWebfonts = copyWebfonts;
exports.copyFonts = uswds.copyFonts;
exports.copyImages = uswds.copyImages;
exports.copyJS = uswds.copyJS;
exports.copyTheme = uswds.copyTheme;
exports.copyAssets = uswds.copyAssets;
exports.update = series(uswds.copyImages, uswds.copyJS);
exports.buildSass = uswds.compile;
exports.watchSass = uswds.watch;
exports.default = this.watch;
