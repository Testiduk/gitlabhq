---
disqus_identifier: 'https://docs.gitlab.com/ee/workflow/notifications.html'
stage: Plan
group: Project Management
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#assignments
---

# Notification emails **(FREE)**

Stay informed about what's happening in GitLab with email notifications.
You can receive updates about activity in issues, merge requests, epics, and designs.

For the tool that GitLab administrators can use to send messages to users, read
[Email from GitLab](../../tools/email.md).

## Receive notifications

You receive notifications for one of the following reasons:

- You participate in an issue, merge request, epic, or design. In this context, _participate_ means
  comment or edit.
- You've [enabled notifications in an issue, merge request, or epic](#notifications-on-issues-merge-requests-and-epics).
- You configured notifications at the [project](#project-notifications) and/or [group](#group-notifications) level.

While notifications are enabled, you receive notification of actions occurring in that issue, merge request, or epic.

NOTE:
Administrators can block notifications, preventing them from being sent.

## Tune your notifications

Getting many notifications can be overwhelming. You can tune the notifications you receive.
For example, you might want to be notified about all activity in a specific project.
For other projects, you only want to be notified when you are mentioned by name.

You can tune the notifications you receive by changing your notification settings:

- [Global notification settings](#global-notification-settings)
- [Notification scope](#notification-scope)
- [Notification levels](#notification-levels)

## Edit notification settings

These notification settings apply only to you. They do not affect the notifications received by
anyone else in the same project or group.

To edit your notification settings:

1. In the top-right corner, select your avatar.
1. Select **Preferences**.
1. On the left sidebar, select **Notifications**.
1. Edit the desired notification settings. Edited settings are automatically saved and enabled.

## Notification scope

You can tune the scope of your notifications by selecting different notification levels for each project and group.

Notification scope is applied from the broadest to most specific levels:

- **Global (default)**: Your global, or _default_, notification level applies if you
  have not selected a notification level for the project or group in which the activity occurred.
- **Group**: For each group, you can select a notification level. Your group setting
  overrides your default setting.
- **Project**: For each project, you can select a notification level. Your project
  setting overrides the group setting.

### Global notification settings

Your **Global notification settings** are the default settings unless you select
different values for a project or a group.

- **Notification email**: the email address your notifications are sent to.
  Defaults to your primary email address.
- **Receive product marketing emails**: select this checkbox to receive
  [periodic emails](#product-marketing-emails) about GitLab features.
- **Global notification level**: the default [notification level](#notification-levels)
  which applies to all your notifications.
- **Receive notifications about your own activity**: select this checkbox to receive
  notifications about your own activity. Not selected by default.

![notification settings](img/notification_global_settings_v13_12.png)

### Group notifications

You can select a notification level and email address for each group.

#### Group notification level

To select a notification level for a group, use either of these methods:

1. In the top-right corner, select your avatar.
1. Select **Preferences**.
1. On the left sidebar, select **Notifications**.
1. Locate the project in the **Groups** section.
1. Select the desired [notification level](#notification-levels).

Or:

1. On the top bar, select **Menu > Groups** and find your group.
1. Select the notification dropdown, next to the bell icon (**{notifications}**).
1. Select the desired [notification level](#notification-levels).

#### Group notification email address

> Introduced in GitLab 12.0

You can select an email address to receive notifications for each group you belong to. This could be useful, for example, if you work freelance, and want to keep email about clients' projects separate.

1. In the top-right corner, select your avatar.
1. Select **Preferences**.
1. On the left sidebar, select **Notifications**.
1. Locate the project in the **Groups** section.
1. Select the desired email address.

### Project notifications

You can select a notification level for each project to help you closely monitor activity in select projects.

To select a notification level for a project, use either of these methods:

1. In the top-right corner, select your avatar.
1. Select **Preferences**.
1. On the left sidebar, select **Notifications**.
1. Locate the project in the **Projects** section.
1. Select the desired [notification level](#notification-levels).

Or:

1. On the top bar, select **Menu > Projects** and find your project.
1. Select the notification dropdown, next to the bell icon (**{notifications}**).
1. Select the desired [notification level](#notification-levels).

<i class="fa fa-youtube-play youtube" aria-hidden="true"></i>
To learn how to be notified when a new release is available, see [Notification for releases](https://www.youtube.com/watch?v=qyeNkGgqmH4).

### Notification levels

For each project and group you can select one of the following levels:

| Level       | Description                                                 |
| ----------- | ----------------------------------------------------------- |
| Global      | Your global settings apply.                                 |
| Watch       | Receive notifications for any activity.                     |
| On mention  | Receive notifications when [mentioned](../project/issues/issue_data_and_actions.md#mentions) in a comment. |
| Participate | Receive notifications for threads you have participated in. |
| Disabled    | Turns off notifications.                                    |
| Custom      | Receive notifications for custom selected events.           |

### Product marketing emails

You can receive emails that teach you about various GitLab features.
This is enabled by default.

To opt out, [edit your notification settings](#edit-notification-settings) and clear the
**Receive product marketing emails** checkbox.

Disabling these emails does not disable all emails.
Learn how to [opt out of all emails from GitLab](#opt-out-of-all-gitlab-emails).

#### Self-managed product marketing emails **(FREE SELF)**

The self-managed installation generates and automatically sends these emails based on user actions.
Turning this on does not cause your GitLab instance or your company to send any personal information to
GitLab Inc.

An instance administrator can configure this setting for all users. If you choose to opt out, your
setting overrides the instance-wide setting, even when an administrator later enables these emails
for all users.

## Notification events

Users are notified of the following events:

<!-- The table is sorted first by recipient, then alphabetically. -->

| Event                        | Sent to             | Settings level               |
|------------------------------|---------------------|------------------------------|
| New release                  | Project members     | Custom notification          |
| Project moved                | Project members (1) | (1) not disabled             |
| Email changed                | User                | Security email, always sent. |
| Group access level changed   | User                | Sent when user group access level is changed |
| New email added              | User                | Security email, always sent. |
| New SAML/SCIM user provisioned | User              | Sent when a user is provisioned through SAML/SCIM. [Introduced](https://gitlab.com/gitlab-org/gitlab/-/issues/276018) in GitLab 13.8 |
| New SSH key added            | User                | Security email, always sent. |
| New user created             | User                | Sent on user creation, except for OmniAuth (LDAP)|
| Password changed             | User                | Security email, always sent when user changes their own password |
| Password changed by administrator | User           | Security email, always sent when an administrator changes the password of another user |
| Personal access tokens expiring soon <!-- Do not delete or lint this instance of future tense --> | User          | Security email, always sent. |
| Personal access tokens have expired | User         | Security email, always sent. |
| Project access level changed | User                | Sent when user project access level is changed |
| SSH key has expired          | User                | Security email, always sent. [Introduced](https://gitlab.com/gitlab-org/gitlab/-/issues/322637) in GitLab 13.12 |
| Two-factor authentication disabled | User          | Security email, always sent. |
| User added to group          | User                | Sent when user is added to group |
| User added to project        | User                | Sent when user is added to project |

## Notifications on issues, merge requests, and epics

To enable notifications on a specific issue, merge request, or epic, you must turn on the
**Notifications** toggle in the right sidebar.

- To subscribe, **turn on** if you are not a participant in the discussion, but want to receive
  notifications on each update.
- To unsubscribe, **turn off** if you are receiving notifications for updates but no longer want to
  receive them, unsubscribe from it.

Turning this toggle off only unsubscribes you from updates related to this issue, merge request, or epic.
Learn how to [opt out of all emails from GitLab](#opt-out-of-all-gitlab-emails).

Turning notifications on in an epic doesn't automatically subscribe you to the issues linked
to the epic.

For most events, the notification is sent to:

- Participants:
  - The author and assignee of the issue/merge request.
  - Authors of comments.
  - Anyone [mentioned](../project/issues/issue_data_and_actions.md#mentions) by username in the title
    or description of the issue, merge request or epic.
  - Anyone with notification level "Participating" or higher that is mentioned by their username in
    any of the comments on the issue, merge request, or epic.
- Watchers: users with notification level "Watch".
- Subscribers: anyone who manually subscribed to the issue, merge request, or epic.
- Custom: Users with notification level "custom" who turned on notifications for any of the events in the following table.

NOTE:
To minimize the number of notifications that do not require any action, in
[GitLab versions 12.9 and later](https://gitlab.com/gitlab-org/gitlab/-/issues/616), eligible
approvers are no longer notified for all the activities in their projects. To receive them they have
to change their user notification settings to **Watch** instead.

The following table presents the events that generate notifications for issues, merge requests, and
epics:

| Event                  | Sent to |
|------------------------|---------|
| Change milestone issue | Subscribers, participants mentioned, and Custom notification level with this event selected |
| Change milestone merge request | Subscribers, participants mentioned, and Custom notification level with this event selected |
| Close epic             |         |
| Close issue            |         |
| Close merge request    |         |
| Due issue              | Participants and Custom notification level with this event selected |
| Failed pipeline        | The author of the pipeline |
| Fixed pipeline         | The author of the pipeline. Enabled by default. [Introduced](https://gitlab.com/gitlab-org/gitlab/-/issues/24309) in GitLab 13.1 |
| Merge merge request    |         |
| Merge when pipeline succeeds | Author, Participants, Watchers, Subscribers, and Custom notification level with this event selected. Custom notification level is ignored for Author, Watchers and Subscribers. [Introduced](https://gitlab.com/gitlab-org/gitlab/-/issues/211961) in GitLab 13.4 |
| Merge request [marked as ready](../project/merge_requests/drafts.md) | Watchers and participants. [Introduced](https://gitlab.com/gitlab-org/gitlab/-/issues/15332) in GitLab 13.10 |
| New comment            | Participants, Watchers, Subscribers, and Custom notification level with this event selected, plus anyone mentioned by `@username` in the comment, with notification level "Mention" or higher |
| New epic               |         |
| New issue              |         |
| New merge request      |         |
| Push to merge request  | Participants and Custom notification level with this event selected |
| Reassign issue         | Participants, Watchers, Subscribers, and Custom notification level with this event selected, plus the old assignee |
| Reassign merge request | Participants, Watchers, Subscribers, and Custom notification level with this event selected, plus the old assignee |
| Remove milestone issue | Subscribers, participants mentioned, and Custom notification level with this event selected |
| Remove milestone merge request | Subscribers, participants mentioned, and Custom notification level with this event selected |
| Reopen epic            |         |
| Reopen issue           |         |
| Reopen merge request   |         |
| Successful pipeline    | The author of the pipeline, if they have the custom notification setting for successful pipelines set. If the pipeline failed previously, a `Fixed pipeline` message is sent for the first successful pipeline after the failure, then a `Successful pipeline` message for any further successful pipelines. |

If the title or description of an issue or merge request is
changed, notifications are sent to any **new** mentions by `@username` as
if they had been mentioned in the original text.

BNy default, you don't receive notifications for issues, merge requests, or epics created
by yourself. You only receive notifications when somebody else comments or adds changes to the ones
that you've created or mentions you, or when an issue is due soon.
To always receive notifications on your own issues and so on, you must turn on
[notifications about your own activity](#global-notification-settings).

If an open merge request becomes unmergeable due to conflict, its author is notified about the cause.
If a user has also set the merge request to automatically merge when pipeline succeeds,
then that user is also notified.

## Notifications on designs

> [Introduced](https://gitlab.com/gitlab-org/gitlab/-/issues/217095) in GitLab 13.6.

Email notifications are sent to the participants when comments are made on a design.

The participants are:

- Authors of the design (can be multiple people if different authors have uploaded different versions of the design).
- Authors of comments on the design.
- Anyone that is [mentioned](../project/issues/issue_data_and_actions.md#mentions) in a comment on the design.

## Opt out of all GitLab emails

If you no longer wish to receive any email notifications:

1. [Go to the Notifications settings page.](#edit-notification-settings)
1. Clear the **Receive product marketing emails** checkbox.
1. Set your **Global notification level** to **Disabled**.
1. Clear the **Receive notifications about your own activity** checkbox.
1. If you belong to any groups or projects, set their notification setting to **Global** or
   **Disabled**.

On self-managed installations, even after doing this, your instance administrator
[can still email you](../../tools/email.md).
To unsubscribe, select the unsubscribe link in one of these emails.

## Filter email

Notification email messages include GitLab-specific headers. You can filter the notification emails based on the content of these headers to better manage your notifications. For example, you could filter all emails for a specific project where you are being assigned either a merge request or issue.

The following table lists all GitLab-specific email headers:

| Header                      | Description                                                             |
|------------------------------------|-------------------------------------------------------------------------|
| `X-GitLab-Group-Id` **(PREMIUM)**    | The group's ID. Only present on notification emails for epics.         |
| `X-GitLab-Group-Path` **(PREMIUM)**  | The group's path. Only present on notification emails for epics.       |
| `X-GitLab-Project`                   | The name of the project the notification belongs to.                     |
| `X-GitLab-Project-Id`                | The project's ID.                                                   |
| `X-GitLab-Project-Path`              | The project's path.                                                 |
| `X-GitLab-(Resource)-ID`             | The ID of the resource the notification is for. The resource, for example, can be `Issue`, `MergeRequest`, `Commit`, or another such resource. |
| `X-GitLab-Discussion-ID`             | The ID of the thread the comment belongs to, in notification emails for comments.    |
| `X-GitLab-Pipeline-Id`               | The ID of the pipeline the notification is for, in notification emails for pipelines. |
| `X-GitLab-Reply-Key`                 | A unique token to support reply by email.                                |
| `X-GitLab-NotificationReason`        | The reason for the notification. This can be `mentioned`, `assigned`, or `own_activity`. |
| `List-Id`                            | The path of the project in an RFC 2919 mailing list identifier. This is useful for email organization with filters, for example. |

### X-GitLab-NotificationReason

The `X-GitLab-NotificationReason` header contains the reason for the notification. The value is one of the following, in order of priority:

- `own_activity`
- `assigned`
- `mentioned`

The reason for the notification is also included in the footer of the notification email. For example an email with the
reason `assigned` has this sentence in the footer:

- `You are receiving this email because you have been assigned an item on <configured GitLab hostname>.`

Notification of other events is being considered for inclusion in the `X-GitLab-NotificationReason` header. For details, see this [related issue](https://gitlab.com/gitlab-org/gitlab/-/issues/20689).

For example, an alert notification email can have one of
[the alert's](../../operations/incident_management/alerts.md) statuses:

- `alert_triggered`
- `alert_acknowledged`
- `alert_resolved`
- `alert_ignored`
