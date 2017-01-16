/* eslint-disable comma-dangle, space-before-function-paren, one-var */
/* global Vue */
/* global Sortable */

require('./board_blank_state');
require('./board_delete');
require('./board_list');
require('./board_header');

(() => {
  const Store = gl.issueBoards.BoardsStore;

  window.gl = window.gl || {};
  window.gl.issueBoards = window.gl.issueBoards || {};

  gl.issueBoards.Board = Vue.extend({
    template: `
      <div
        class="board"
        :class="{ 'is-draggable': !list.preset }"
        :data-id="list.id">
        <div class="board-inner">
          <board-header
            :disabled="disabled"
            :list="list"
            :can-admin-issue="canAdminIssue"
            :can-admin-list="canAdminList">
          </board-header>
          <board-list
            v-if="list.type !== 'blank'"
            :list="list"
            :issues="list.issues"
            :loading="list.loading"
            :disabled="disabled"
            :issue-link-base="issueLinkBase"
            :can-create-issue="canCreateIssue"
            ref="board-list">
          </board-list>
          <board-blank-state v-if="list.id == 'blank'">
          </board-blank-state>
        </div>
      </div>
    `,
    components: {
      'board-list': gl.issueBoards.BoardList,
      'board-blank-state': gl.issueBoards.BoardBlankState,
      'board-header': gl.issueBoards.BoardHeader,
    },
    props: {
      list: Object,
      disabled: Boolean,
      issueLinkBase: String,
      rootPath: String,
      canCreateIssue: Boolean,
      canAdminIssue: Boolean,
      canAdminList: Boolean,
    },
    data () {
      return {
        detailIssue: Store.detail,
        filters: Store.state.filters,
      };
    },
    watch: {
      filters: {
        handler () {
          this.list.page = 1;
          this.list.getIssues(true);
        },
        deep: true
      },
      detailIssue: {
        handler () {
          if (!Object.keys(this.detailIssue.issue).length) return;

          const issue = this.list.findIssue(this.detailIssue.issue.id);

          if (issue) {
            const offsetLeft = this.$el.offsetLeft;
            const boardsList = document.querySelectorAll('.boards-list')[0];
            const left = boardsList.scrollLeft - offsetLeft;
            let right = (offsetLeft + this.$el.offsetWidth);

            if (window.innerWidth > 768 && boardsList.classList.contains('is-compact')) {
              // -290 here because width of boardsList is animating so therefore
              // getting the width here is incorrect
              // 290 is the width of the sidebar
              right -= (boardsList.offsetWidth - 290);
            } else {
              right -= boardsList.offsetWidth;
            }

            if (right - boardsList.scrollLeft > 0) {
              $(boardsList).animate({
                scrollLeft: right
              }, this.sortableOptions.animation);
            } else if (left > 0) {
              $(boardsList).animate({
                scrollLeft: offsetLeft
              }, this.sortableOptions.animation);
            }
          }
        },
        deep: true
      }
    },
    mounted () {
      this.sortableOptions = gl.issueBoards.getBoardSortableDefaultOptions({
        disabled: this.disabled,
        group: 'boards',
        draggable: '.is-draggable',
        handle: '.js-board-handle',
        onEnd: (e) => {
          gl.issueBoards.onEnd();

          if (e.newIndex !== undefined && e.oldIndex !== e.newIndex) {
            const order = this.sortable.toArray();
            const list = Store.findList('id', parseInt(e.item.dataset.id, 10));

            this.$nextTick(() => {
              Store.moveList(list, order);
            });
          }
        }
      });

      this.sortable = Sortable.create(this.$el.parentNode, this.sortableOptions);
    },
  });
})();
