import I from 'immutable';

function actives(m) {
  return I.Map(m);
}

function setActive(m, page) {
  return m.mapEntries(
    (kv) => {
      if (kv[0] == page) {
        return [kv[0], true];
      }
      return [kv[0], false];
    });
}

export default {
  "actives" : actives,
  "setActive" : setActive
};
