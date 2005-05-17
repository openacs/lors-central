<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../form-md-record/md-record"
    ims_md_id="@ims_md_id;noquote@"
/>

<hr>

<h3>List of Meta Metadata Catalog-Entries</h3>
<blockquote>
  <table cellspacing="2" cellpadding="2" border="0" width="50%">
    <tr class="form-section">
      <th colspan="2">Meta Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Catalog-Entries: </td>
      <td><listtemplate name= "d_md_cata"></listtemplate></td>
    </tr>   

  </table>
</blockquote>
<p>

<h3>Add/Edit Meta Metadata Catalog-Entry</h3>
<blockquote>
 <formtemplate id="metamd_cata" style="standard-lars"></formtemplate>
</blockquote>
