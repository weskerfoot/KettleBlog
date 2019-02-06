import riot from 'riot';
import './editor.tag';
import { default as RiotControl } from 'riotcontrol';
import { default as promise } from 'es6-promise';
import { default as smooth } from 'smoothscroll-polyfill';
import { default as showdown } from 'showdown';
import 'element-closest';

promise.Promise.polyfill();
smooth.polyfill();

window.showdown = showdown;
window.RiotControl = RiotControl;

RiotControl.addStore(new riot.observable());

riot.mount("editor");
