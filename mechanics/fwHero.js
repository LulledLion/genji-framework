var Hero;
var Result;
if (Array.isArray(Hero)){
    Result = Hero.map(i => '#!include "mechanics/' + i).join('.opy"\n');
}
else{
    Result ='#!include "mechanics/' + Hero + '.opy"\nmacro FwHero = Hero.' + Hero + '\n';
}
Hero = Result