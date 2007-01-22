<master>
  <property name="title">@page_title@</property>
  <property name="header_stuff">@header_stuff@</property>
  <property name="context">@context@</property>
  <property name="focus">@focus@</property>
  <property name="robots">noindex,nofollow</property>

  <property name="header_stuff">
    <style type="text/css">
    .hint {
      font-style: italic;
    }
    .url {
      color: green;
    }
    .result {
      margin: 1em 0 0 0;
      padding: 0 0 0 1em;
      border-left: 3px solid grey;
    }
    .result b {
      background: yellow;
      padding: 0 3px;
    }
    </style>
  </property>
  
<formtemplate id="search" style="inline"></formtemplate>

<br />
  <include src="/packages/search/lib/search-results" q="@q@" extra_q="@extra_q@">
