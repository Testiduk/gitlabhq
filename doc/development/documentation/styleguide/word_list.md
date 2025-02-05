---
stage: none
group: Style Guide
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#assignments
description: 'Writing styles, markup, formatting, and other standards for GitLab Documentation.'
---

# A-Z word list

To help ensure consistency in the documentation, follow this guidance.

For guidance not on this page, we defer to these style guides:

- [Microsoft Style Guide](https://docs.microsoft.com/en-us/style-guide/welcome/)
- [Google Developer Documentation Style Guide](https://developers.google.com/style)

<!-- vale off -->
<!-- markdownlint-disable -->

## `@mention`

Try to avoid **`@mention`**. Say **mention** instead, and consider linking to the
[mentions topic](../../../user/project/issues/issue_data_and_actions.md#mentions).
Don't use backticks.

## above

Try to avoid using **above** when referring to an example or table in a documentation page. If required, use **previous** instead. For example:

- In the previous example, the dog had fleas.

## admin, admin area

Use **administration**, **administrator**, **administer**, or **Admin Area** instead. ([Vale](../testing.md#vale) rule: [`Admin.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/Admin.yml))

## allow, enable

Try to avoid **allow** and **enable**, unless you are talking about security-related features. For example:

- Do: Use this feature to create a pipeline.
- Do not: This feature allows you to create a pipeline.

This phrasing is more active and is from the user perspective, rather than the person who implemented the feature.
[View details in the Microsoft style guide](https://docs.microsoft.com/en-us/style-guide/a-z-word-list-term-collections/a/allow-allows).

## Alpha

Use uppercase for **Alpha**. For example: **The XYZ feature is in Alpha.** or **This Alpha release is ready to test.**

You might also want to link to [this section](https://about.gitlab.com/handbook/product/gitlab-the-product/#alpha-beta-ga)
in the handbook when writing about Alpha features.

## and/or

Instead of **and/or**, use **or** or rewrite the sentence to spell out both options.

## area

Use [**section**](#section) instead of **area**. The only exception is [the Admin Area](#admin-admin-area).

## below

Try to avoid **below** when referring to an example or table in a documentation page. If required, use **following** instead. For example:

- In the following example, the dog has fleas.

## Beta

Use uppercase for **Beta**. For example: **The XYZ feature is in Beta.** or **This Beta release is ready to test.**

You might also want to link to [this section](https://about.gitlab.com/handbook/product/gitlab-the-product/#alpha-beta-ga)
in the handbook when writing about Beta features.

## blacklist

Do not use **blacklist**. Another option is **denylist**. ([Vale](../testing.md#vale) rule: [`InclusionCultural.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/InclusionCultural.yml))

## board

Use lowercase for **boards**, **issue boards**, and **epic boards**.

## box

Use **text box** to refer to the UI field. Do not use **field** or **box**. For example:

- In the **Variable name** text box, enter `my text`.

## button

Don't use a descriptor with **button**.

- Do: Select **Run pipelines**.
- Do not: Select the **Run pipelines** button.

## cannot, can not

Use **cannot** instead of **can not**. You can also use **can't**.

See also [contractions](index.md#contractions).

## checkbox

Use one word for **checkbox**. Do not use **check box**.

You **select** (not **check** or **enable**) and **clear** (not **deselect** or **disable**) checkboxes.
For example:

- Select the **Protect environment** checkbox.
- Clear the **Protect environment** checkbox.

If you must refer to the checkbox, you can say it is selected or cleared. For example:

- Ensure the **Protect environment** checkbox is cleared.
- Ensure the **Protect environment** checkbox is selected.

## CI/CD

CI/CD is always uppercase. No need to spell it out on first use.

## click

Do not use **click**. Instead, use **select** with buttons, links, menu items, and lists.
**Select** applies to more devices, while **click** is more specific to a mouse.

## collapse

Use **collapse** instead of **close** when you are talking about expanding or collapsing a section in the UI.

## confirmation dialog

Use **confirmation dialog** to describe the dialog box that asks you to confirm your action. For example:

- On the confirmation dialog, select **OK**.

## currently

Do not use **currently** when talking about the product or its features. The documentation describes the product as it is today.
([Vale](../testing.md#vale) rule: [`CurrentStatus.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/CurrentStatus.yml))

## deploy board

Use lowercase for **deploy board**.

## Developer

When writing about the Developer role:

- Use a capital **D**.
- Do not use bold.
- Do not use the phrase, **if you are a developer** to mean someone who is assigned the Developer
  role. Instead, write it out. For example, **if you are assigned the Developer role**.
- To describe a situation where the Developer role is the minimum required:
  - Avoid: the Developer role or higher
  - Use instead: at least the Developer role

Do not use **Developer permissions**. A user who is assigned the Developer role has a set of associated permissions.

## disable

See [the Microsoft style guide](https://docs.microsoft.com/en-us/style-guide/a-z-word-list-term-collections/d/disable-disabled) for guidance on **disable**.
Use **inactive** or **off** instead. ([Vale](../testing.md#vale) rule: [`InclusionAbleism.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/InclusionAbleism.yml))

## dropdown, dropdown list

Do not use. Use **list** instead.

Include the descriptor when writing about lists. Start with the list name,
then follow with the item the user should select. For example:

- From the **Visibility** list, select **Public**.

## earlier

Use **earlier** when talking about version numbers.

- Do: In GitLab 14.1 and earlier.
- Do not: In GitLab 14.1 and lower.

## easily

Do not use **easily**. If the user doesn't find the process to be easy, we lose their trust.

## e.g.

Do not use Latin abbreviations. Use **for example**, **such as**, **for instance**, or **like** instead. ([Vale](../testing.md#vale) rule: [`LatinTerms.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/LatinTerms.yml))

## email

Do not use **e-mail** with a hyphen. When plural, use **emails** or **email messages**.

## enable

See [the Microsoft style guide](https://docs.microsoft.com/en-us/style-guide/a-z-word-list-term-collections/e/enable-enables) for guidance on **enable**.
Use **active** or **on** instead. ([Vale](../testing.md#vale) rule: [`InclusionAbleism.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/InclusionAbleism.yml))

## enter

Use **enter** instead of **type** when talking about putting values into text boxes.

## epic

Use lowercase for **epic**.

## epic board

Use lowercase for **epic board**.

## etc.

Try to avoid **etc.**. Be as specific as you can. Do not use **and so on** as a replacement.

- Do: You can update objects, like merge requests and issues.
- Do not: You can update objects, like merge requests, issues, etc.

## expand

Use **expand** instead of **open** when you are talking about expanding or collapsing a section in the UI.

## field

Use **box** instead of **field** or **text box**.

- Avoid: In the **Variable name** field, enter `my text`.
- Use instead: In the **Variable name** box, enter `my text`.

## foo

Do not use **foo** in product documentation. You can use it in our API and contributor documentation, but try to use a clearer and more meaningful example instead.

## future tense

When possible, use present tense instead of future tense. For example, use **after you execute this command, GitLab displays the result** instead of **after you execute this command, GitLab will display the result**. ([Vale](../testing.md#vale) rule: [`FutureTense.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/FutureTense.yml))

## Geo

Use title case for **Geo**.

## GitLab

Do not make **GitLab** possessive (GitLab's). This guidance follows [GitLab Trademark Guidelines](https://about.gitlab.com/handbook/marketing/corporate-marketing/brand-activation/trademark-guidelines/).

## GitLab.com

**GitLab.com** refers to the GitLab instance managed by GitLab itself.

## GitLab SaaS

**GitLab SaaS** refers to the product license that provides access to GitLab.com. It does not refer to the
GitLab instance managed by GitLab itself.

## GitLab Runner

Use title case for **GitLab Runner**. This is the product you install. See also [runners](#runner-runners) and [this issue](https://gitlab.com/gitlab-org/gitlab/-/issues/233529).

## GitLab self-managed

Use **GitLab self-managed** to refer to the product license for GitLab instances managed by customers themselves.

## Guest

When writing about the Guest role:

- Use a capital **G**.
- Do not use bold.
- Do not use the phrase, **if you are a guest** to mean someone who is assigned the Guest
  role. Instead, write it out. For example, **if you are assigned the Guest role**.
- To describe a situation where the Guest role is the minimum required:
  - Avoid: the Guest role or higher
  - Use instead: at least the Guest role

Do not use **Guest permissions**. A user who is assigned the Guest role has a set of associated permissions.

## handy

Do not use **handy**. If the user doesn't find the feature or process to be handy, we lose their trust.

## high availability, HA

Do not use **high availability** or **HA**. Instead, direct readers to the GitLab [reference architectures](../../../administration/reference_architectures/index.md) for information about configuring GitLab for handling greater amounts of users.

## higher

Do not use **higher** when talking about version numbers.

- Do: In GitLab 14.1 and later.
- Do not: In GitLab 14.1 and higher.

## hit

Don't use **hit** to mean **press**.

- Avoid: Hit the **ENTER** button.
- Use instead: Press **ENTER**.

## I

Do not use first-person singular. Use **you**, **we**, or **us** instead. ([Vale](../testing.md#vale) rule: [`FirstPerson.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/FirstPerson.yml))

## i.e.

Do not use Latin abbreviations. Use **that is** instead. ([Vale](../testing.md#vale) rule: [`LatinTerms.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/LatinTerms.yml))

## in order to

Do not use **in order to**. Use **to** instead. ([Vale](../testing.md#vale) rule: [`Wordy.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/Wordy.yml))

## issue

Use lowercase for **issue**.

## issue board

Use lowercase for **issue board**.

## issue weights

Use lowercase for **issue weights**.

## job

Do not use **build** to be synonymous with **job**. A job is defined in the `.gitlab-ci.yml` file and runs as part of a pipeline.

If you want to use **CI** with the word **job**, use **CI/CD job** rather than **CI job**.

## later

Use **later** when talking about version numbers.

- Avoid: In GitLab 14.1 and higher.
- Use instead: In GitLab 14.1 and later.

## list

Use instead of **dropdown**, **drop-down** or **dropdown list**. You select an item from a list. For example:

- From the **Availability** list, select **public**.

The list name, and the items you select, should be bold.

## log in, log on

Do not use **log in** or **log on**. Use [sign in](#sign-in) instead. If the user interface has **Log in**, you can use it.

## lower

Do not use **lower** when talking about version numbers.

- Do: In GitLab 14.1 and earlier.
- Do not: In GitLab 14.1 and lower.

## Maintainer

When writing about the Maintainer role:

- Use a capital **M**.
- Do not use bold.
- Do not use the phrase, **if you are a maintainer** to mean someone who is assigned the Maintainer
  role. Instead, write it out. For example, **if you are assigned the Maintainer role**.
- To describe a situation where the Maintainer role is the minimum required:
  - Avoid: the Maintainer role or higher
  - Use instead: at least the Maintainer role

Do not use **Maintainer permissions**. A user who is assigned the Maintainer role has a set of associated permissions.

## mankind

Do not use **mankind**. Use **people** or **humanity** instead. ([Vale](../testing.md#vale) rule: [`InclusionGender.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/InclusionGender.yml))

## manpower

Do not use **manpower**. Use words like **workforce** or **GitLab team members**. ([Vale](../testing.md#vale) rule: [`InclusionGender.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/InclusionGender.yml))

## master

Do not use **master**. Options are **primary** or **main**. ([Vale](../testing.md#vale) rule: [`InclusionCultural.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/InclusionCultural.yml))

## may, might

**Might** means something has the probability of occurring. **May** gives permission to do something. Consider **can** instead of **may**.

## me, myself, mine

Do not use first-person singular. Use **you**, **we**, or **us** instead. ([Vale](../testing.md#vale) rule: [`FirstPerson.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/FirstPerson.yml))

## merge requests

Use lowercase for **merge requests**. If you use **MR** as the acronym, spell it out on first use.

## milestones

Use lowercase for **milestones**.

## navigate

Do not use **navigate**. Use **go** instead. For example:

- Go to this webpage.
- Open a terminal and go to the `runner` directory.

## need to, should

Try to avoid **needs to**, because it's wordy. Avoid **should** when you can be more specific. If something is required, use **must**.

- Do: You must set the variable. Or: Set the variable.
- Do not: You need to set the variable.

**Should** is acceptable for recommended actions or items, or in cases where an event may not
happen. For example:

- Although you can configure the installation manually, you should use the express configuration to
  avoid complications.
- You should see a success message in the console. Contact support if an error message appears
  instead.

## note that

Do not use **note that** because it's wordy.

- Do: You can change the settings.
- Do not: Note that you can change the settings.

## Owner

When writing about the Owner role:

- Use a capital **O**.
- Do not use bold.
- Do not use the phrase, **if you are an owner** to mean someone who is assigned the Owner
  role. Instead, write it out. For example, **if you are assigned the Owner role**.

Do not use **Owner permissions**. A user who is assigned the Owner role has a set of associated permissions.

## permissions

Do not use **roles** and **permissions** interchangeably. Each user is assigned a role. Each role includes a set of permissions.

## please

Do not use **please**. For details, see the [Microsoft style guide](https://docs.microsoft.com/en-us/style-guide/a-z-word-list-term-collections/p/please).

## press

Use **press** when talking about keyboard keys. For example:

- To stop the command, press <kbd>Control</kbd>+<kbd>C</kbd>.

## profanity

Do not use profanity. Doing so may negatively affect other users and contributors, which is contrary to the GitLab value of [Diversity, Inclusion, and Belonging](https://about.gitlab.com/handbook/values/#diversity-inclusion).

## Reporter

When writing about the Reporter role:

- Use a capital **R**.
- Do not use bold.
- Do not use the phrase, **if you are a reporter** to mean someone who is assigned the Reporter
  role. Instead, write it out. For example, **if you are assigned the Reporter role**.
- To describe a situation where the Reporter role is the minimum required:
  - Avoid: the Reporter role or higher
  - Use instead: at least the Reporter role

Do not use **Reporter permissions**. A user who is assigned the Reporter role has a set of associated permissions.

## Repository Mirroring

Use title case for **Repository Mirroring**.

## roles

Do not use **roles** and **permissions** interchangeably. Each user is assigned a role. Each role includes a set of permissions.

## runner, runners

Use lowercase for **runners**. These are the agents that run CI/CD jobs. See also [GitLab Runner](#gitlab-runner) and [this issue](https://gitlab.com/gitlab-org/gitlab/-/issues/233529).

## sanity check

Do not use **sanity check**. Use **check for completeness** instead. ([Vale](../testing.md#vale) rule: [`InclusionAbleism.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/InclusionAbleism.yml))

## scalability

Do not use **scalability** when talking about increasing GitLab performance for additional users. The words scale or scaling
are sometimes acceptable, but references to increasing GitLab performance for additional users should direct readers
to the GitLab [reference architectures](../../../administration/reference_architectures/index.md) page.

## section

Use **section** to describe an area on a page. For example, if a page has lines that separate the UI
into separate areas, refer to these areas as sections.

We often think of expandable/collapsible areas as **sections**. When you refer to expanding
or collapsing a section, don't include the word **section**.

- Do: Expand **Auto DevOps**.
- Do not: Expand the **Auto DevOps** section.

## select

Use **select** with buttons, links, menu items, and lists. **Select** applies to more devices,
while **click** is more specific to a mouse.

## setup, set up

Use **setup** as a noun, and **set up** as a verb. For example:

- Your remote office setup is amazing.
- To set up your remote office correctly, consider the ergonomics of your work area.

## sign in

Use **sign in** instead of **sign on** or **log on** or **log in**. If the user interface has different words, use those.

You can use **single sign-on**.

## simply, simple

Do not use **simply** or **simple**. If the user doesn't find the process to be simple, we lose their trust.

## slashes

Instead of **and/or**, use **or** or re-write the sentence. This rule also applies to other slashes, like **follow/unfollow**. Some exceptions (like **CI/CD**) are allowed.

## slave

Do not use **slave**. Another option is **secondary**. ([Vale](../testing.md#vale) rule: [`InclusionCultural.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/InclusionCultural.yml))

## subgroup

Use **subgroup** (no hyphen) instead of **sub-group**.

## that

Do not use **that** when describing a noun. For example:

- Do: The file you save...
- Do not: The file **that** you save...

See also [this, these, that, those](#this-these-that-those).

## terminal

Use lowercase for **terminal**. For example:

- Open a terminal.
- From a terminal, run the `docker login` command.

## text box

Use **text box** instead of **field** or **box** when referring to the UI element.

## there is, there are

Try to avoid **there is** and **there are**. These phrases hide the subject.

- Do: The bucket has holes.
- Do not: There are holes in the bucket.

## they

Avoid the use of gender-specific pronouns, unless referring to a specific person.
Use a singular [they](https://developers.google.com/style/pronouns#gender-neutral-pronouns) as
a gender-neutral pronoun.

## this, these, that, those

Always follow these words with a noun. For example:

- Do: **This setting** improves performance.
- Do not: **This** improves performance.

- Do: **These pants** are the best.
- Do not: **These** are the best.

- Do: **That droid** is the one you are looking for.
- Do not: **That** is the one you are looking for.

- Do: **Those settings** need to be configured. (Or even better, **Configure those settings.**)
- Do not: **Those** need to be configured.

## to-do item

Use lowercase and hyphenate **to-do** item. ([Vale](../testing.md#vale) rule: [`ToDo.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/ToDo.yml))

## To-Do List

Use title case for **To-Do List**. ([Vale](../testing.md#vale) rule: [`ToDo.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/ToDo.yml))

## toggle

You **turn on** or **turn off** a toggle. For example:

- Turn on the **blah** toggle.

## type

Do not use **type** if you can avoid it. Use **enter** instead.

## useful

Do not use **useful**. If the user doesn't find the process to be useful, we lose their trust.

## utilize

Do not use **utilize**. Use **use** instead. It's more succinct and easier for non-native English speakers to understand.

## Value Stream Analytics

Use title case for **Value Stream Analytics**.

## via

Do not use Latin abbreviations. Use **with**, **through**, or **by using** instead. ([Vale](../testing.md#vale) rule: [`LatinTerms.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/LatinTerms.yml))

## we

Try to avoid **we** and focus instead on how the user can accomplish something in GitLab.

- Do: Use widgets when you have work you want to organize.
- Do not: We created a feature for you to add widgets.

One exception: You can use **we recommend** instead of **it is recommended** or **GitLab recommends**.

## whitelist

Do not use **whitelist**. Another option is **allowlist**. ([Vale](../testing.md#vale) rule: [`InclusionCultural.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/.vale/gitlab/InclusionCultural.yml))

<!-- vale on -->
<!-- markdownlint-enable -->
