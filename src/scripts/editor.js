import riot from 'riot';
import { default as RiotControl } from 'riotcontrol';
import { default as promise } from 'es6-promise';
import { default as smooth } from 'smoothscroll-polyfill';
import 'element-closest';

promise.Promise.polyfill();
smooth.polyfill();

window.RiotControl = RiotControl;

RiotControl.addStore(new riot.observable());

riot.mount("editor");
