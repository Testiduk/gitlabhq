import { numberToHumanSize } from '~/lib/utils/number_utils';
import { PROJECT_STORAGE_TYPES } from './constants';

/**
 * This method parses the results from `getProjectStorageCount` call.
 *
 * @param {Object} data graphql result
 * @returns {Object}
 */
export const parseGetProjectStorageResults = (data, helpLinks) => {
  const projectStatistics = data?.project?.statistics;
  if (!projectStatistics) {
    return {};
  }
  const { storageSize, ...storageStatistics } = projectStatistics;
  const storageTypes = PROJECT_STORAGE_TYPES.reduce((types, currentType) => {
    if (!storageStatistics[currentType.id]) {
      return types;
    }

    const helpPathKey = currentType.id.replace(`Size`, `HelpPagePath`);
    const helpPath = helpLinks[helpPathKey];

    return types.concat({
      storageType: {
        ...currentType,
        helpPath,
      },
      value: numberToHumanSize(storageStatistics[currentType.id], 1),
    });
  }, []);

  return {
    storage: {
      totalUsage: numberToHumanSize(storageSize, 1),
      storageTypes,
    },
    statistics: projectStatistics,
  };
};
