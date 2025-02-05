import { Editor } from '@tiptap/vue-2';
import { isFunction } from 'lodash';
import { PROVIDE_SERIALIZER_OR_RENDERER_ERROR } from '../constants';
import Attachment from '../extensions/attachment';
import Audio from '../extensions/audio';
import Blockquote from '../extensions/blockquote';
import Bold from '../extensions/bold';
import BulletList from '../extensions/bullet_list';
import Code from '../extensions/code';
import CodeBlockHighlight from '../extensions/code_block_highlight';
import DescriptionItem from '../extensions/description_item';
import DescriptionList from '../extensions/description_list';
import Division from '../extensions/division';
import Document from '../extensions/document';
import Dropcursor from '../extensions/dropcursor';
import Emoji from '../extensions/emoji';
import Figure from '../extensions/figure';
import FigureCaption from '../extensions/figure_caption';
import Gapcursor from '../extensions/gapcursor';
import HardBreak from '../extensions/hard_break';
import Heading from '../extensions/heading';
import History from '../extensions/history';
import HorizontalRule from '../extensions/horizontal_rule';
import HTMLMarks from '../extensions/html_marks';
import Image from '../extensions/image';
import InlineDiff from '../extensions/inline_diff';
import Italic from '../extensions/italic';
import Link from '../extensions/link';
import ListItem from '../extensions/list_item';
import Loading from '../extensions/loading';
import OrderedList from '../extensions/ordered_list';
import Paragraph from '../extensions/paragraph';
import Reference from '../extensions/reference';
import Strike from '../extensions/strike';
import Subscript from '../extensions/subscript';
import Superscript from '../extensions/superscript';
import Table from '../extensions/table';
import TableCell from '../extensions/table_cell';
import TableHeader from '../extensions/table_header';
import TableRow from '../extensions/table_row';
import TaskItem from '../extensions/task_item';
import TaskList from '../extensions/task_list';
import Text from '../extensions/text';
import Video from '../extensions/video';
import { ContentEditor } from './content_editor';
import createMarkdownSerializer from './markdown_serializer';
import trackInputRulesAndShortcuts from './track_input_rules_and_shortcuts';

const createTiptapEditor = ({ extensions = [], ...options } = {}) =>
  new Editor({
    extensions: [...extensions],
    editorProps: {
      attributes: {
        class: 'gl-outline-0!',
      },
    },
    ...options,
  });

export const createContentEditor = ({
  renderMarkdown,
  uploadsPath,
  extensions = [],
  serializerConfig = { marks: {}, nodes: {} },
  tiptapOptions,
} = {}) => {
  if (!isFunction(renderMarkdown)) {
    throw new Error(PROVIDE_SERIALIZER_OR_RENDERER_ERROR);
  }

  const builtInContentEditorExtensions = [
    Attachment.configure({ uploadsPath, renderMarkdown }),
    Audio,
    Blockquote,
    Bold,
    BulletList,
    Code,
    CodeBlockHighlight,
    DescriptionItem,
    DescriptionList,
    Document,
    Division,
    Dropcursor,
    Emoji,
    Figure,
    FigureCaption,
    Gapcursor,
    HardBreak,
    Heading,
    History,
    HorizontalRule,
    ...HTMLMarks,
    Image,
    InlineDiff,
    Italic,
    Link,
    ListItem,
    Loading,
    OrderedList,
    Paragraph,
    Reference,
    Strike,
    Subscript,
    Superscript,
    TableCell,
    TableHeader,
    TableRow,
    Table,
    TaskItem,
    TaskList,
    Text,
    Video,
  ];

  const allExtensions = [...builtInContentEditorExtensions, ...extensions];
  const trackedExtensions = allExtensions.map(trackInputRulesAndShortcuts);
  const tiptapEditor = createTiptapEditor({ extensions: trackedExtensions, ...tiptapOptions });
  const serializer = createMarkdownSerializer({ render: renderMarkdown, serializerConfig });

  return new ContentEditor({ tiptapEditor, serializer });
};
