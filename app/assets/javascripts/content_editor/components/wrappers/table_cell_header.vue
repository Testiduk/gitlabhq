<script>
import TableCellBase from './table_cell_base.vue';

export default {
  name: 'TableCellHeader',
  components: {
    TableCellBase,
  },
  props: {
    editor: {
      type: Object,
      required: true,
    },
    getPos: {
      type: Function,
      required: true,
    },
  },
};
</script>
<template>
  <table-cell-base cell-type="th" v-bind="$props" />
</template>
