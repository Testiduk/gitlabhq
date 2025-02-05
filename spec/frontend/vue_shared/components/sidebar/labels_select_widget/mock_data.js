export const mockRegularLabel = {
  id: 26,
  title: 'Foo Label',
  description: 'Foobar',
  color: '#BADA55',
  textColor: '#FFFFFF',
};

export const mockScopedLabel = {
  id: 27,
  title: 'Foo::Bar',
  description: 'Foobar',
  color: '#0033CC',
  textColor: '#FFFFFF',
};

export const mockLabels = [
  mockRegularLabel,
  mockScopedLabel,
  {
    id: 28,
    title: 'Bug',
    description: 'Label for bugs',
    color: '#FF0000',
    textColor: '#FFFFFF',
  },
  {
    id: 29,
    title: 'Boog',
    description: 'Label for bugs',
    color: '#FF0000',
    textColor: '#FFFFFF',
  },
];

export const mockConfig = {
  allowMultiselect: true,
  labelsListTitle: 'Assign labels',
  labelsCreateTitle: 'Create label',
  variant: 'sidebar',
  selectedLabels: [mockRegularLabel, mockScopedLabel],
  labelsSelectInProgress: false,
  labelsFilterBasePath: '/gitlab-org/my-project/issues',
  labelsFilterParam: 'label_name',
  footerCreateLabelTitle: 'create',
  footerManageLabelTitle: 'manage',
};

export const mockSuggestedColors = {
  '#009966': 'Green-cyan',
  '#8fbc8f': 'Dark sea green',
  '#3cb371': 'Medium sea green',
  '#00b140': 'Green screen',
  '#013220': 'Dark green',
  '#6699cc': 'Blue-gray',
  '#0000ff': 'Blue',
  '#e6e6fa': 'Lavendar',
  '#9400d3': 'Dark violet',
  '#330066': 'Deep violet',
  '#808080': 'Gray',
  '#36454f': 'Charcoal grey',
  '#f7e7ce': 'Champagne',
  '#c21e56': 'Rose red',
  '#cc338b': 'Magenta-pink',
  '#dc143c': 'Crimson',
  '#ff0000': 'Red',
  '#cd5b45': 'Dark coral',
  '#eee600': 'Titanium yellow',
  '#ed9121': 'Carrot orange',
  '#c39953': 'Aztec Gold',
};

export const createLabelSuccessfulResponse = {
  data: {
    labelCreate: {
      label: {
        id: 'gid://gitlab/ProjectLabel/126',
        color: '#dc143c',
        description: null,
        title: 'ewrwrwer',
        __typename: 'Label',
      },
      errors: [],
      __typename: 'LabelCreatePayload',
    },
  },
};

export const labelsQueryResponse = {
  data: {
    workspace: {
      labels: {
        nodes: [
          {
            color: '#330066',
            description: null,
            id: 'gid://gitlab/ProjectLabel/1',
            title: 'Label1',
          },
          {
            color: '#2f7b2e',
            description: null,
            id: 'gid://gitlab/ProjectLabel/2',
            title: 'Label2',
          },
        ],
      },
    },
  },
};
