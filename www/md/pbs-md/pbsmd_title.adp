<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../../lib/md-record-pbs"
    ims_md_id="@ims_md_id;noquote@"
/>

<hr>

<h3>List of General Metadata Titles</h3>
<blockquote>
  <table cellspacing="2" cellpadding="2" border="0" width="50%">
    <tr class="form-section">
      <th colspan="2">General Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Titles: </td>
      <td><listtemplate name= "d_gen_titles"></listtemplate></td>
    </tr>   

  </table>
</blockquote>
<p>

<h3>Add/Edit General Metadata Title</h3>
<blockquote>
 <formtemplate id="generalmd_title" style="standard-lars"></formtemplate>
</blockquote>
