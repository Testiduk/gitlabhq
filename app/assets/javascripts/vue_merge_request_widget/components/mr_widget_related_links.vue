<script>
import { s__, n__ } from '~/locale';

export default {
  name: 'MRWidgetRelatedLinks',
  props: {
    relatedLinks: {
      type: Object,
      required: true,
      default: () => ({}),
    },
    state: {
      type: String,
      required: false,
      default: '',
    },
  },
  computed: {
    closesText() {
      if (this.state === 'merged') {
        return s__('mrWidget|Closed');
      }
      if (this.state === 'closed') {
        return s__('mrWidget|Did not close');
      }

      return n__('mrWidget|Closes issue', 'mrWidget|Closes issues', this.relatedLinks.closingCount);
    },
  },
};
</script>
<template>
  <section class="mr-info-list gl-ml-7 gl-pb-5">
    <p v-if="relatedLinks.closing">
      {{ closesText }}
      <span v-html="relatedLinks.closing /* eslint-disable-line vue/no-v-html */"></span>
    </p>
    <p v-if="relatedLinks.mentioned">
      {{ n__('mrWidget|Mentions issue', 'mrWidget|Mentions issues', relatedLinks.mentionedCount) }}
      <span v-html="relatedLinks.mentioned /* eslint-disable-line vue/no-v-html */"></span>
    </p>
    <p v-if="relatedLinks.assignToMe">
      <span v-html="relatedLinks.assignToMe /* eslint-disable-line vue/no-v-html */"></span>
    </p>
  </section>
</template>
