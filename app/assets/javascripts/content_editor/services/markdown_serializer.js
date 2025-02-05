import {
  MarkdownSerializer as ProseMirrorMarkdownSerializer,
  defaultMarkdownSerializer,
} from 'prosemirror-markdown/src/to_markdown';
import { DOMParser as ProseMirrorDOMParser } from 'prosemirror-model';
import Audio from '../extensions/audio';
import Blockquote from '../extensions/blockquote';
import Bold from '../extensions/bold';
import BulletList from '../extensions/bullet_list';
import Code from '../extensions/code';
import CodeBlockHighlight from '../extensions/code_block_highlight';
import DescriptionItem from '../extensions/description_item';
import DescriptionList from '../extensions/description_list';
import Division from '../extensions/division';
import Emoji from '../extensions/emoji';
import Figure from '../extensions/figure';
import FigureCaption from '../extensions/figure_caption';
import HardBreak from '../extensions/hard_break';
import Heading from '../extensions/heading';
import HorizontalRule from '../extensions/horizontal_rule';
import HTMLMarks from '../extensions/html_marks';
import Image from '../extensions/image';
import InlineDiff from '../extensions/inline_diff';
import Italic from '../extensions/italic';
import Link from '../extensions/link';
import ListItem from '../extensions/list_item';
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
import {
  isPlainURL,
  renderHardBreak,
  renderTable,
  renderTableCell,
  renderTableRow,
  openTag,
  closeTag,
  renderOrderedList,
  renderImage,
  renderPlayable,
  renderHTMLNode,
} from './serialization_helpers';

const defaultSerializerConfig = {
  marks: {
    [Bold.name]: defaultMarkdownSerializer.marks.strong,
    [Code.name]: defaultMarkdownSerializer.marks.code,
    [Italic.name]: { open: '_', close: '_', mixable: true, expelEnclosingWhitespace: true },
    [Subscript.name]: { open: '<sub>', close: '</sub>', mixable: true },
    [Superscript.name]: { open: '<sup>', close: '</sup>', mixable: true },
    [InlineDiff.name]: {
      mixable: true,
      open(state, mark) {
        return mark.attrs.type === 'addition' ? '{+' : '{-';
      },
      close(state, mark) {
        return mark.attrs.type === 'addition' ? '+}' : '-}';
      },
    },
    [Link.name]: {
      open(state, mark, parent, index) {
        return isPlainURL(mark, parent, index, 1) ? '<' : '[';
      },
      close(state, mark, parent, index) {
        const href = mark.attrs.canonicalSrc || mark.attrs.href;

        return isPlainURL(mark, parent, index, -1)
          ? '>'
          : `](${state.esc(href)}${mark.attrs.title ? ` ${state.quote(mark.attrs.title)}` : ''})`;
      },
    },
    [Strike.name]: {
      open: '~~',
      close: '~~',
      mixable: true,
      expelEnclosingWhitespace: true,
    },
    ...HTMLMarks.reduce(
      (acc, { name }) => ({
        ...acc,
        [name]: {
          mixable: true,
          open(state, node) {
            return openTag(name, node.attrs);
          },
          close: closeTag(name),
        },
      }),
      {},
    ),
  },

  nodes: {
    [Audio.name]: renderPlayable,
    [Blockquote.name]: (state, node) => {
      if (node.attrs.multiline) {
        state.write('>>>');
        state.ensureNewLine();
        state.renderContent(node);
        state.ensureNewLine();
        state.write('>>>');
        state.closeBlock(node);
      } else {
        state.wrapBlock('> ', null, node, () => state.renderContent(node));
      }
    },
    [BulletList.name]: defaultMarkdownSerializer.nodes.bullet_list,
    [CodeBlockHighlight.name]: (state, node) => {
      state.write(`\`\`\`${node.attrs.language || ''}\n`);
      state.text(node.textContent, false);
      state.ensureNewLine();
      state.write('```');
      state.closeBlock(node);
    },
    [Division.name]: renderHTMLNode('div'),
    [DescriptionList.name]: renderHTMLNode('dl', true),
    [DescriptionItem.name]: (state, node, parent, index) => {
      if (index === 1) state.ensureNewLine();
      renderHTMLNode(node.attrs.isTerm ? 'dt' : 'dd')(state, node);
      if (index === parent.childCount - 1) state.ensureNewLine();
    },
    [Emoji.name]: (state, node) => {
      const { name } = node.attrs;

      state.write(`:${name}:`);
    },
    [Figure.name]: renderHTMLNode('figure'),
    [FigureCaption.name]: renderHTMLNode('figcaption'),
    [HardBreak.name]: renderHardBreak,
    [Heading.name]: defaultMarkdownSerializer.nodes.heading,
    [HorizontalRule.name]: defaultMarkdownSerializer.nodes.horizontal_rule,
    [Image.name]: renderImage,
    [ListItem.name]: defaultMarkdownSerializer.nodes.list_item,
    [OrderedList.name]: renderOrderedList,
    [Paragraph.name]: defaultMarkdownSerializer.nodes.paragraph,
    [Reference.name]: (state, node) => {
      state.write(node.attrs.originalText || node.attrs.text);
    },
    [Table.name]: renderTable,
    [TableCell.name]: renderTableCell,
    [TableHeader.name]: renderTableCell,
    [TableRow.name]: renderTableRow,
    [TaskItem.name]: (state, node) => {
      state.write(`[${node.attrs.checked ? 'x' : ' '}] `);
      state.renderContent(node);
    },
    [TaskList.name]: (state, node) => {
      if (node.attrs.numeric) renderOrderedList(state, node);
      else defaultMarkdownSerializer.nodes.bullet_list(state, node);
    },
    [Text.name]: defaultMarkdownSerializer.nodes.text,
    [Video.name]: renderPlayable,
  },
};

/**
 * A markdown serializer converts arbitrary Markdown content
 * into a ProseMirror document and viceversa. To convert Markdown
 * into a ProseMirror document, the Markdown should be rendered.
 *
 * The client should provide a render function to allow flexibility
 * on the desired rendering approach.
 *
 * @param {Function} params.render Render function
 * that parses the Markdown and converts it into HTML.
 * @returns a markdown serializer
 */
export default ({ render = () => null, serializerConfig = {} } = {}) => ({
  /**
   * Converts a Markdown string into a ProseMirror JSONDocument based
   * on a ProseMirror schema.
   * @param {ProseMirror.Schema} params.schema A ProseMirror schema that defines
   * the types of content supported in the document
   * @param {String} params.content An arbitrary markdown string
   * @returns A ProseMirror JSONDocument
   */
  deserialize: async ({ schema, content }) => {
    const html = await render(content);

    if (!html) return null;

    const parser = new DOMParser();
    const { body } = parser.parseFromString(html, 'text/html');

    // append original source as a comment that nodes can access
    body.append(document.createComment(content));

    const state = ProseMirrorDOMParser.fromSchema(schema).parse(body);

    return state.toJSON();
  },

  /**
   * Converts a ProseMirror JSONDocument based
   * on a ProseMirror schema into Markdown
   * @param {ProseMirror.Schema} params.schema A ProseMirror schema that defines
   * the types of content supported in the document
   * @param {String} params.content A ProseMirror JSONDocument
   * @returns A Markdown string
   */
  serialize: ({ schema, content }) => {
    const proseMirrorDocument = schema.nodeFromJSON(content);
    const serializer = new ProseMirrorMarkdownSerializer(
      {
        ...defaultSerializerConfig.nodes,
        ...serializerConfig.nodes,
      },
      {
        ...defaultSerializerConfig.marks,
        ...serializerConfig.marks,
      },
    );

    return serializer.serialize(proseMirrorDocument, {
      tightLists: true,
    });
  },
});
