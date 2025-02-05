<script>
import { GlLink, GlSprintf } from '@gitlab/ui';
import { s__ } from '~/locale';
import {
  PACKAGE_TYPE_NUGET,
  PACKAGE_TYPE_CONAN,
  PACKAGE_TYPE_MAVEN,
  PACKAGE_TYPE_COMPOSER,
  PACKAGE_TYPE_PYPI,
} from '~/packages_and_registries/package_registry/constants';
import ClipboardButton from '~/vue_shared/components/clipboard_button.vue';
import DetailsRow from '~/vue_shared/components/registry/details_row.vue';

export default {
  i18n: {
    sourceText: s__('PackageRegistry|Source project located at %{link}'),
    licenseText: s__('PackageRegistry|License information located at %{link}'),
    recipeText: s__('PackageRegistry|Recipe: %{recipe}'),
    appGroup: s__('PackageRegistry|App group: %{group}'),
    appName: s__('PackageRegistry|App name: %{name}'),
    targetShaCopyButton: s__('PackageRegistry|Copy target SHA'),
    targetSha: s__('PackageRegistry|Target SHA: %{sha}'),
    composerJson: s__(
      'PackageRegistry|Composer.json with license: %{license} and version: %{version}',
    ),
    requiredPython: s__('PackageRegistry|Required Python: %{pythonVersion}'),
  },
  components: {
    DetailsRow,
    GlLink,
    GlSprintf,
    ClipboardButton,
  },
  props: {
    packageEntity: {
      type: Object,
      required: true,
    },
  },
  computed: {
    showMetadata() {
      return (
        [
          PACKAGE_TYPE_NUGET,
          PACKAGE_TYPE_CONAN,
          PACKAGE_TYPE_MAVEN,
          PACKAGE_TYPE_COMPOSER,
          PACKAGE_TYPE_PYPI,
        ].includes(this.packageEntity.packageType) && this.packageEntity.metadata
      );
    },
    showNugetMetadata() {
      return this.packageEntity.packageType === PACKAGE_TYPE_NUGET;
    },
    showConanMetadata() {
      return this.packageEntity.packageType === PACKAGE_TYPE_CONAN;
    },
    showMavenMetadata() {
      return this.packageEntity.packageType === PACKAGE_TYPE_MAVEN;
    },
    showComposerMetadata() {
      return this.packageEntity.packageType === PACKAGE_TYPE_COMPOSER;
    },
    showPypiMetadata() {
      return this.packageEntity.packageType === PACKAGE_TYPE_PYPI;
    },
  },
};
</script>

<template>
  <div v-if="showMetadata">
    <h3 class="gl-font-lg" data-testid="title">{{ __('Additional Metadata') }}</h3>

    <div class="gl-bg-gray-50 gl-inset-border-1-gray-100 gl-rounded-base" data-testid="main">
      <template v-if="showNugetMetadata">
        <details-row icon="project" padding="gl-p-4" dashed data-testid="nuget-source">
          <gl-sprintf :message="$options.i18n.sourceText">
            <template #link>
              <gl-link :href="packageEntity.metadata.projectUrl" target="_blank">{{
                packageEntity.metadata.projectUrl
              }}</gl-link>
            </template>
          </gl-sprintf>
        </details-row>
        <details-row icon="license" padding="gl-p-4" data-testid="nuget-license">
          <gl-sprintf :message="$options.i18n.licenseText">
            <template #link>
              <gl-link :href="packageEntity.metadata.licenseUrl" target="_blank">{{
                packageEntity.metadata.licenseUrl
              }}</gl-link>
            </template>
          </gl-sprintf>
        </details-row>
      </template>

      <details-row
        v-else-if="showConanMetadata"
        icon="information-o"
        padding="gl-p-4"
        data-testid="conan-recipe"
      >
        <gl-sprintf :message="$options.i18n.recipeText">
          <template #recipe>{{ packageEntity.metadata.recipe }}</template>
        </gl-sprintf>
      </details-row>

      <template v-else-if="showMavenMetadata">
        <details-row icon="information-o" padding="gl-p-4" dashed data-testid="maven-app">
          <gl-sprintf :message="$options.i18n.appName">
            <template #name>
              <strong>{{ packageEntity.metadata.appName }}</strong>
            </template>
          </gl-sprintf>
        </details-row>
        <details-row icon="information-o" padding="gl-p-4" data-testid="maven-group">
          <gl-sprintf :message="$options.i18n.appGroup">
            <template #group>
              <strong>{{ packageEntity.metadata.appGroup }}</strong>
            </template>
          </gl-sprintf>
        </details-row>
      </template>

      <template v-else-if="showComposerMetadata">
        <details-row icon="information-o" padding="gl-p-4" dashed data-testid="composer-target-sha">
          <gl-sprintf :message="$options.i18n.targetSha">
            <template #sha>
              <strong>{{ packageEntity.metadata.targetSha }}</strong>
              <clipboard-button
                :title="$options.i18n.targetShaCopyButton"
                :text="packageEntity.metadata.targetSha"
                category="tertiary"
                css-class="gl-p-0!"
              />
            </template>
          </gl-sprintf>
        </details-row>
        <details-row icon="information-o" padding="gl-p-4" data-testid="composer-json">
          <gl-sprintf :message="$options.i18n.composerJson">
            <template #license>
              <strong>{{ packageEntity.metadata.composerJson.license }}</strong>
            </template>
            <template #version>
              <strong>{{ packageEntity.metadata.composerJson.version }}</strong>
            </template>
          </gl-sprintf>
        </details-row>
      </template>

      <details-row
        v-else-if="showPypiMetadata"
        icon="information-o"
        padding="gl-p-4"
        data-testid="pypi-required-python"
      >
        <gl-sprintf :message="$options.i18n.requiredPython">
          <template #pythonVersion>
            <strong>{{ packageEntity.metadata.requiredPython }}</strong>
          </template>
        </gl-sprintf>
      </details-row>
    </div>
  </div>
</template>
