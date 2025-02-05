import { GlLink, GlSprintf } from '@gitlab/ui';
import { shallowMountExtended } from 'helpers/vue_test_utils_helper';
import {
  conanMetadata,
  mavenMetadata,
  nugetMetadata,
  packageData,
  composerMetadata,
  pypiMetadata,
} from 'jest/packages_and_registries/package_registry/mock_data';
import component from '~/packages_and_registries/package_registry/components/details/additional_metadata.vue';
import {
  PACKAGE_TYPE_NUGET,
  PACKAGE_TYPE_CONAN,
  PACKAGE_TYPE_MAVEN,
  PACKAGE_TYPE_NPM,
  PACKAGE_TYPE_COMPOSER,
  PACKAGE_TYPE_PYPI,
} from '~/packages_and_registries/package_registry/constants';
import ClipboardButton from '~/vue_shared/components/clipboard_button.vue';
import DetailsRow from '~/vue_shared/components/registry/details_row.vue';

const mavenPackage = { packageType: PACKAGE_TYPE_MAVEN, metadata: mavenMetadata() };
const conanPackage = { packageType: PACKAGE_TYPE_CONAN, metadata: conanMetadata() };
const nugetPackage = { packageType: PACKAGE_TYPE_NUGET, metadata: nugetMetadata() };
const composerPackage = { packageType: PACKAGE_TYPE_COMPOSER, metadata: composerMetadata() };
const pypiPackage = { packageType: PACKAGE_TYPE_PYPI, metadata: pypiMetadata() };
const npmPackage = { packageType: PACKAGE_TYPE_NPM, metadata: {} };

describe('Package Additional Metadata', () => {
  let wrapper;
  const defaultProps = {
    packageEntity: {
      ...packageData(mavenPackage),
    },
  };

  const mountComponent = (props) => {
    wrapper = shallowMountExtended(component, {
      propsData: { ...defaultProps, ...props },
      stubs: {
        DetailsRow,
        GlSprintf,
      },
    });
  };

  afterEach(() => {
    wrapper.destroy();
    wrapper = null;
  });

  const findTitle = () => wrapper.findByTestId('title');
  const findMainArea = () => wrapper.findByTestId('main');
  const findNugetSource = () => wrapper.findByTestId('nuget-source');
  const findNugetLicense = () => wrapper.findByTestId('nuget-license');
  const findConanRecipe = () => wrapper.findByTestId('conan-recipe');
  const findMavenApp = () => wrapper.findByTestId('maven-app');
  const findMavenGroup = () => wrapper.findByTestId('maven-group');
  const findElementLink = (container) => container.findComponent(GlLink);
  const findComposerTargetSha = () => wrapper.findByTestId('composer-target-sha');
  const findComposerTargetShaCopyButton = () => wrapper.findComponent(ClipboardButton);
  const findComposerJson = () => wrapper.findByTestId('composer-json');
  const findPypiRequiredPython = () => wrapper.findByTestId('pypi-required-python');

  it('has the correct title', () => {
    mountComponent();

    const title = findTitle();

    expect(title.exists()).toBe(true);
    expect(title.text()).toBe('Additional Metadata');
  });

  it.each`
    packageEntity      | visible  | packageType
    ${mavenPackage}    | ${true}  | ${PACKAGE_TYPE_MAVEN}
    ${conanPackage}    | ${true}  | ${PACKAGE_TYPE_CONAN}
    ${nugetPackage}    | ${true}  | ${PACKAGE_TYPE_NUGET}
    ${composerPackage} | ${true}  | ${PACKAGE_TYPE_COMPOSER}
    ${pypiPackage}     | ${true}  | ${PACKAGE_TYPE_PYPI}
    ${npmPackage}      | ${false} | ${PACKAGE_TYPE_NPM}
  `(
    `It is $visible that the component is visible when the package is $packageType`,
    ({ packageEntity, visible }) => {
      mountComponent({ packageEntity });

      expect(findTitle().exists()).toBe(visible);
      expect(findMainArea().exists()).toBe(visible);
    },
  );

  describe('nuget metadata', () => {
    beforeEach(() => {
      mountComponent({ packageEntity: nugetPackage });
    });

    it.each`
      name         | finderFunction      | text                                           | link            | icon
      ${'source'}  | ${findNugetSource}  | ${'Source project located at projectUrl'}      | ${'projectUrl'} | ${'project'}
      ${'license'} | ${findNugetLicense} | ${'License information located at licenseUrl'} | ${'licenseUrl'} | ${'license'}
    `('$name element', ({ finderFunction, text, link, icon }) => {
      const element = finderFunction();
      expect(element.exists()).toBe(true);
      expect(element.text()).toBe(text);
      expect(element.props('icon')).toBe(icon);
      expect(findElementLink(element).attributes('href')).toBe(nugetPackage.metadata[link]);
    });
  });

  describe('conan metadata', () => {
    beforeEach(() => {
      mountComponent({ packageEntity: conanPackage });
    });

    it.each`
      name        | finderFunction     | text                                                       | icon
      ${'recipe'} | ${findConanRecipe} | ${'Recipe: package-8/1.0.0@gitlab-org+gitlab-test/stable'} | ${'information-o'}
    `('$name element', ({ finderFunction, text, icon }) => {
      const element = finderFunction();
      expect(element.exists()).toBe(true);
      expect(element.text()).toBe(text);
      expect(element.props('icon')).toBe(icon);
    });
  });

  describe('maven metadata', () => {
    beforeEach(() => {
      mountComponent();
    });

    it.each`
      name       | finderFunction    | text                     | icon
      ${'app'}   | ${findMavenApp}   | ${'App name: appName'}   | ${'information-o'}
      ${'group'} | ${findMavenGroup} | ${'App group: appGroup'} | ${'information-o'}
    `('$name element', ({ finderFunction, text, icon }) => {
      const element = finderFunction();
      expect(element.exists()).toBe(true);
      expect(element.text()).toBe(text);
      expect(element.props('icon')).toBe(icon);
    });
  });

  describe('composer metadata', () => {
    beforeEach(() => {
      mountComponent({ packageEntity: composerPackage });
    });

    it.each`
      name               | finderFunction           | text                                                      | icon
      ${'target-sha'}    | ${findComposerTargetSha} | ${'Target SHA: b83d6e391c22777fca1ed3012fce84f633d7fed0'} | ${'information-o'}
      ${'composer-json'} | ${findComposerJson}      | ${'Composer.json with license: MIT and version: 1.0.0'}   | ${'information-o'}
    `('$name element', ({ finderFunction, text, icon }) => {
      const element = finderFunction();
      expect(element.exists()).toBe(true);
      expect(element.text()).toBe(text);
      expect(element.props('icon')).toBe(icon);
    });

    it('target-sha has a copy button', () => {
      expect(findComposerTargetShaCopyButton().exists()).toBe(true);
      expect(findComposerTargetShaCopyButton().props()).toMatchObject({
        text: 'b83d6e391c22777fca1ed3012fce84f633d7fed0',
        title: 'Copy target SHA',
      });
    });
  });

  describe('pypi metadata', () => {
    beforeEach(() => {
      mountComponent({ packageEntity: pypiPackage });
    });

    it.each`
      name                      | finderFunction            | text                        | icon
      ${'pypi-required-python'} | ${findPypiRequiredPython} | ${'Required Python: 1.0.0'} | ${'information-o'}
    `('$name element', ({ finderFunction, text, icon }) => {
      const element = finderFunction();
      expect(element.exists()).toBe(true);
      expect(element.text()).toBe(text);
      expect(element.props('icon')).toBe(icon);
    });
  });
});
