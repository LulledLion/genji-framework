//String.prototype.replaceAll = function (search, replace) { return this.split(search).join(replace); };
//String.prototype.replaceAll = function (search, replace) { return this.replace(new RegExp(search.replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&"), "g"), replace); };
content = content.replace(`        Set Player Variable(Event Player, __languageIndex__, 0.1);`, "");
content = content.replace(
`rule ("OverPy | Global Init") {
    event {
        Ongoing - Global;
    }
    actions {`,
`rule ("OverPy | Global Init") {
    event {
        Ongoing - Global;
    }
    actions {
        Disable Inspector Recording;`)
content;