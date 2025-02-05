import Vue from 'vue';
import Translate from '~/vue_shared/translate';
import HeaderSearchApp from './components/app.vue';
import createStore from './store';

Vue.use(Translate);

export const initHeaderSearchApp = () => {
  const el = document.getElementById('js-header-search');

  if (!el) {
    return false;
  }

  const { issuesPath, mrPath } = el.dataset;
  let { searchContext } = el.dataset;
  searchContext = JSON.parse(searchContext);

  return new Vue({
    el,
    store: createStore({ issuesPath, mrPath, searchContext }),
    render(createElement) {
      return createElement(HeaderSearchApp);
    },
  });
};
