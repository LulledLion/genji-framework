var Hero;
var Result;
if (Array.isArray(Hero)){
    Result = Hero.map(i => '#!include "mechanics/' + i).join('.opy"\n');
}
else{
    Result =
'enum FwHero:\n' +
    '\tHero = Hero.' + Hero.toUpperCase() + '\n' +
    '\tName = "' + Hero.toUpperCase() + '"\n' +
'#!define FwHero@Hero @Hero ' + Hero.toLowerCase() + '\n' +
'#!include "mechanics/' + Hero + '.opy"\n';
}
Hero = Result